# Docker container for DSC https://github.com/stephenslab/dsc

# Pull base image
FROM gaow/lab-base:latest

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install tools
WORKDIR /tmp
ENV VERSION master
ADD https://github.com/stephenslab/dsc/archive/${VERSION}.tar.gz dsc.tar.gz
RUN tar zxf dsc.tar.gz \
    && cd dsc-${VERSION} \
    && /opt/miniconda3/bin/pip install -U --upgrade-strategy only-if-needed --no-cache-dir .
RUN Rscript -e 'devtools::install_github("stephenslab/dsc", subdir="dscrutils", force=TRUE)'
RUN rm -rf *

# Default command
CMD ["bash"]