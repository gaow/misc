# Docker container for WASP https://github.com/bmvdgeijn/WASP
# Pull base image
FROM conda/miniconda2:latest

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install tools
WORKDIR /data
ENV VERSION master
ADD https://github.com/bmvdgeijn/WASP/archive/${VERSION}.zip WASP.zip
RUN apt-get -qq update \
    && apt-get -qq -y install unzip \
    && conda install -y pytables=2.4.0 && pip install pysam \
    && unzip WASP.zip \
    && mv WASP-${VERSION} /opt/WASP \
    && apt-get -qq -y remove unzip \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes
RUN rm -rf *

# Default command
CMD ["bash"]
