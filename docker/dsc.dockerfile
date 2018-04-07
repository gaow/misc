# Docker container for DSC https://github.com/stephenslab/dsc
# Pull base image
FROM r-base:latest

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install tools
WORKDIR /data
ENV VERSION master
RUN apt-get -qq update \
    && apt-get -qq -y install \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libsqlite3-dev \
    libxml2-dev \
    libssh2-1-dev \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log
RUN install2.r --error devtools testthat repr IRdisplay evaluate crayon pbdZMQ uuid digest
ADD https://repo.continuum.io/miniconda/Miniconda3-4.4.10-Linux-x86_64.sh miniconda.sh
RUN /bin/bash miniconda.sh -b -p /opt/miniconda3 && \
    /opt/miniconda3/bin/conda clean -tipsy && \
    ln -s /opt/miniconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh
ADD https://github.com/stephenslab/dsc/archive/${VERSION}.tar.gz dsc.tar.gz
RUN /opt/miniconda3/bin/conda install -y -c conda-forge fasteners python-xxhash pyarrow \
    && /opt/miniconda3/bin/conda install numpy pandas sqlalchemy msgpack-python sympy numexpr h5py \
                psutil networkx pydotplus pyyaml tqdm pygments pexpect \
    && /opt/miniconda3/bin/conda clean --all -y
RUN /opt/miniconda3/bin/pip install --no-cache-dir sos sos-pbs sos-bash sos-notebook sos-r jupyter-client bash_kernel \
    && /opt/miniconda3/bin/python -m bash_kernel.install \
    && /opt/miniconda3/bin/python -m sos_notebook.install
RUN tar zxf dsc.tar.gz \
    && cd dsc-${VERSION} \
    && /opt/miniconda3/bin/pip install -U --upgrade-strategy only-if-needed --no-cache-dir .
ENV PATH /opt/miniconda3/bin:$PATH
RUN Rscript -e 'devtools::install_github("IRkernel/IRkernel"); IRkernel::installspec()' \
    && Rscript -e 'devtools::install_github("stephenslab/dsc",subdir = "dscrutils",force = TRUE)'
RUN rm -rf *

# Default command
CMD ["bash"]