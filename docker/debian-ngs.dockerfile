# Docker container for NGS tools mostly from Debian official repo 
# - apt-get install tabix bwa bowtie2 tophat samtools bedtools
# - github master: STAR, bcftools
# - SRAToolKit 2.8.2-1 developed by NCBI Genbank/SRA team.

# Pull base image.
FROM debian:stable-slim

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install tools
WORKDIR /tmp
ENV SRAVERSION 2.8.2-1
ENV GITVERSION master
RUN apt-get update -y \
    && apt-get install -qq -y --no-install-recommends \
    curl ca-certificates \
    tabix bwa bowtie2 tophat samtools bedtools \
    build-essential zlib1g-dev libbz2-dev liblzma-dev \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log
RUN curl -L \
    http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${SRAVERSION}/sratoolkit.${SRAVERSION}-ubuntu64.tar.gz \
    -o sra.tar.gz \
    && tar zxvf sra.tar.gz \
    && mv sratoolkit.${SRAVERSION}-ubuntu64/bin/* /usr/local/bin \
    && rm -rf /tmp/*
RUN curl -L \
    https://github.com/alexdobin/STAR/archive/${GITVERSION}.tar.gz -o STAR.tar.gz \
    && tar zxvf STAR.tar.gz \
    && cd STAR-${GITVERSION}/source \
    && make STAR \
    && mv STAR /usr/local/bin \
    && rm -rf /tmp/*
RUN curl -L \
    https://github.com/samtools/htslib/archive/${GITVERSION}.tar.gz -o htslib.tar.gz \
    && curl -L \
    https://github.com/samtools/bcftools/archive/${GITVERSION}.tar.gz -o bcftools.tar.gz \
    && tar zxvf htslib.tar.gz \
    && mv htslib-${GITVERSION} htslib \
    && tar zxvf bcftools.tar.gz \
    && mv bcftools-${GITVERSION} bcftools \
    && cd bcftools \
    && make \
    && make install \
    && rm -rf /tmp/*
RUN echo '#!/bin/bash bzip2 -dc "$@"' > /usr/local/bin/bzcat \
    && sed -i 's/ /\n/' /usr/local/bin/bzcat \
    && chmod +x /usr/local/bin/bzcat

# Default command
CMD ["bash"]
