FROM jupyter/base-notebook:hub-1.0.0

MAINTAINER Gao Wang <gw2411@columbia.edu>

USER root

# Tools
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    apt-transport-https \
    build-essential \
    cmake \
    gfortran \
    libgfortran-6-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libsqlite3-dev \
    libxml2-dev \
    libssh2-1-dev \
    libc6-dev \
    libgomp1 \
    libatlas3-base \
    && apt-get install -y --no-install-recommends ghostscript graphviz pandoc nodejs libmagickwand-dev \
    && apt-get install -y --no-install-recommends dirmngr gpg-agent software-properties-common \
    && apt-get install -y --no-install-recommends less vim nano openssh-client rsync \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# A hack for ImageMagick policy issue
# to allow view PDF files in SoS Notebook
RUN sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read|write" pattern="PDF" \/>/g' /etc/ImageMagick-6/policy.xml

# R environment, for version cran35
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9 \
    && add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' \
    && apt-get update \
    && apt-get install -y --no-install-recommends r-base r-base-dev r-base-core \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

RUN R --slave -e "for (p in c('dplyr', 'stringr', 'readr', 'magrittr', 'ggplot2', 'cowplot', 'IRkernel', 'feather', 'remotes')) if (!(p %in% rownames(installed.packages()))) install.packages(p, repos = 'http://cran.rstudio.com')"

USER jovyan
# "jovyan" stands for "Jupyter User"

# https://stat.ethz.ch/R-manual/R-devel/library/base/html/Startup.html
# If you want ‘~/.Renviron’ or ‘~/.Rprofile’ to be ignored by child R processes (such as those run by R CMD check and R CMD build), set the appropriate environment variable R_ENVIRON_USER or R_PROFILE_USER to (if possible, which it is not on Windows) "" or to the name of a non-existent file.
ENV R_ENVIRON_USER ""
ENV R_PROFILE_USER ""
ENV R_LIBS_USER " "

# Bash
RUN pip install bash_kernel --no-cache-dir
RUN python -m bash_kernel.install

# Markdown kernel
RUN pip install markdown-kernel --no-cache-dir
RUN python -m markdown_kernel.install 

# A ipynb to docx converter
RUN pip install jupyter-docx-bundler --no-cache-dir
RUN jupyter bundlerextension enable --py jupyter_docx_bundler --sys-prefix

# Some setup for JupyterHub
RUN pip install dockerspawner jupyterhub-tmpauthenticator --no-cache-dir

# SoS Suite
RUN pip install docker markdown wand graphviz imageio pillow nbformat jupyterlab feather-format --no-cache-dir
RUN jupyter labextension install transient-display-data @jupyterlab/toc

## Trigger rerun for sos updates
ARG DUMMY=unknown
RUN DUMMY=${DUMMY} pip install sos sos-notebook sos-r sos-python sos-bash --no-cache-dir
RUN python -m sos_notebook.install
RUN R --slave -e "IRkernel::installspec()"
RUN jupyter labextension install jupyterlab-sos

# To build
#docker build --build-arg DUMMY=`date +%s` -t gaow/base-notebook -f base-notebook.dockerfile .
#docker push gaow/base-notebook
