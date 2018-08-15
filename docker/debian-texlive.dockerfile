# Docker container for texlive that comes with Debian sid

# Pull base image.
FROM debian:sid-slim

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install tools
WORKDIR /tmp
RUN apt-get update -y \
    && apt-get install -qq -y texlive-full python-pygments pandoc pandoc-citeproc \
	fonts-wqy-microhei ttf-wqy-microhei fonts-wqy-zenhei ttf-wqy-zenhei \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf * /var/lib/apt/lists/* /var/log/dpkg.log
# cjk-fonts.tar.gz on host machine, contains simhei.tff, simsun.ttc, simkai.ttf, simfang.ttf
COPY cjk-fonts.tar.gz ./
RUN mkdir -p /usr/share/fonts/truetype && \
    tar zxf cjk-fonts.tar.gz -C /usr/share/fonts/truetype && \
    fc-cache && mktexlsr && rm -rf *
# Default command
CMD ["bash"]
