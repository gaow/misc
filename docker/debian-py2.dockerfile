# Docker container for Python 2 environment based on Debian Jessie
# Mainly serve as base image for SEQPower and SEQLinkage

# Pull base image
FROM debian:jessie-slim

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install tools
WORKDIR /tmp
ENV MCVERSION 2-4.4.10
RUN apt-get update -y && apt-get install -yq --no-install-recommends \
    build-essential swig libsqlite3-dev libbz2-dev zlib1g-dev libssl-dev libcurl4-openssl-dev \
    libopenblas-base r-base r-base-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
ADD https://repo.continuum.io/miniconda/Miniconda${MCVERSION}-Linux-x86_64.sh ./
RUN (echo ''; echo yes; echo /opt/miniconda2) | bash Miniconda${MCVERSION}-Linux-x86_64.sh
RUN /opt/miniconda2/bin/conda install -y numpy pandas scipy scikit-learn numexpr \
    h5py pytables sqlalchemy matplotlib && /opt/miniconda2/bin/conda clean --all -y
RUN /opt/miniconda2/bin/pip install --no-cache-dir simuPOP==1.1.7.1
RUN rm -rf /*

ENV PATH /opt/miniconda2/bin:$PATH
ENV PYTHON_EGG_CACHE /tmp/.python-eggs

# Default command
CMD ["bash"]
