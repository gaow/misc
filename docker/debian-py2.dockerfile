# Docker container for Python 2 environment

# Pull base image
FROM debian:jessie-slim

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install tools
WORKDIR /data
ENV MCVERSION 2-4.4.10
RUN apt-get update -y && apt-get install -yq --no-install-recommends \
    build-essential swig libbz2-dev zlib1g-dev r-cran-ggplot2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
ADD https://repo.continuum.io/miniconda/Miniconda${MCVERSION}-Linux-x86_64.sh ./
RUN (echo ''; echo yes; echo /opt/miniconda2) | bash Miniconda${MCVERSION}-Linux-x86_64.sh
RUN /opt/miniconda2/bin/conda install -y numpy pandas scipy scikit-learn numexpr \
    h5py sqlalchemy matplotlib pytables 
RUN rm -rf /data/*

ENV PATH /opt/miniconda2/bin:$PATH

# Default command
CMD ["bash"]