# Add GATK4 to debian-ngs

FROM gaow/debian-ngs:latest

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install tools
WORKDIR /tmp
ENV VERSION 4.0.3.0
## https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN mkdir -p /usr/share/man/man1
RUN apt-get update -y \
    && apt-get install -qq -y --no-install-recommends \
    default-jdk python3 python3-matplotlib r-base \
    build-essential zlib1g-dev libbz2-dev liblzma-dev \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log
ADD https://github.com/broadinstitute/gatk/releases/download/${VERSION}/gatk-${VERSION}.zip ./
ADD https://raw.githubusercontent.com/broadinstitute/gatk/master/scripts/docker/gatkbase/install_R_packages.R ./
RUN unzip gatk-${VERSION}.zip \
    && mv gatk-${VERSION} /opt \
    && ln -s /opt/gatk-${VERSION}/gatk /usr/local/bin/gatk \
    && Rscript install_R_packages.R
RUN ln -s /usr/bin/python3 /usr/local/bin/python
RUN rm -rf *

# Default command
CMD ["bash"]
