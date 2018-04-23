# Docker container for DSC https://github.com/stephenslab/dsc

# Pull base image
FROM gaow/lab-base:latest

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install tools
WORKDIR /tmp
ENV VERSION master
RUN curl -L https://github.com/stephenslab/dsc/archive/${VERSION}.tar.gz -o dsc.tar.gz \
    && tar zxf dsc.tar.gz \
    && cd dsc-${VERSION} \
    && pip install -U --upgrade-strategy only-if-needed --no-cache-dir . \
    && Rscript -e 'devtools::install_github("stephenslab/dsc", subdir="dscrutils", force=TRUE)' \
    && rm -rf /tmp/* $HOME/.cache

# Default command
CMD ["bash"]
