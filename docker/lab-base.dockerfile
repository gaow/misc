# Docker container for R and Python

FROM debian:stretch-slim

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Setup environment
WORKDIR /tmp
ENV MRO_VERSION 3.4.4
ENV MINICONDA_VERSION 4.4.10
ENV PATH /opt/miniconda3/bin:/opt/microsoft/ropen/$MRO_VERSION/lib64/R/bin:$PATH
ENV LD_LIBRARY_PATH /opt/microsoft/ropen/$MRO_VERSION/lib64/R/lib:$LD_LIBRARY_PATH
ENV C_INCLUDE_PATH /opt/microsoft/ropen/$MRO_VERSION/lib64/R/include:$C_INCLUDE_PATH
ENV CPLUS_INCLUDE_PATH /opt/microsoft/ropen/$MRO_VERSION/lib64/R/include:$CPLUS_INCLUDE_PATH

# Install dev libraries
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    build-essential \
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# Install MRO & MKL 
RUN curl https://mran.blob.core.windows.net/install/mro/$MRO_VERSION/microsoft-r-open-$MRO_VERSION.tar.gz -o MRO.tar.gz \
    && tar -xzf MRO.tar.gz && cd microsoft-r-open && ./install.sh -a -u && rm -rf /tmp/*

# Install Python packages
RUN curl https://repo.continuum.io/miniconda/Miniconda3-$MINICONDA_VERSION-Linux-x86_64.sh -o MCON.sh \
    && /bin/bash MCON.sh -b -p /opt/miniconda3 \
    && ln -s /opt/miniconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && conda install mkl numpy scipy pandas matplotlib psutil \ 
    && conda clean --all -tipsy && rm -rf /tmp/* $HOME/.cache

# Install R packages
ENV LIBLOC /opt/microsoft/ropen/$MRO_VERSION/lib64/R/library
ADD https://raw.githubusercontent.com/gaow/misc/master/R/install.R /opt/microsoft/ropen/$MRO_VERSION/lib64/R/bin
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"), download.file.method = "libcurl")' \
    > /opt/microsoft/ropen/$MRO_VERSION/lib64/R/etc/Rprofile.site \
    && chmod +x /opt/microsoft/ropen/$MRO_VERSION/lib64/R/bin/install.R && sync \
    && install.R curl httr devtools testthat ggplot2 && rm -rf /tmp/*

# # Add a user called "docker" with given IDs and add it to staff group
# RUN groupadd --gid 1000 docker \
#     && useradd --uid 1000 --gid 1000 \
#        --create-home --shell /bin/bash \
#        docker \
#     && addgroup docker staff

# Default command
CMD ["bash"]