# Docker container for NGS tools mostly from Debian official repo 
# - apt-get install tabix bwa bowtie2 tophat samtools bedtools
# - SRAToolKit 2.8.2-1 developed by NCBI Genbank/SRA team.
# - STAR aligner 2.5.4b

# Pull base image.
FROM debian:stable-slim

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install tools
WORKDIR /opt
ENV SRAVERSION 2.8.2-1
ENV STARVERSION 2.5.4b
RUN apt-get update -y && apt-get install -yq --no-install-recommends \
    tabix bwa bowtie2 tophat samtools bedtools \
    build-essential zlib1g-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
ADD https://github.com/alexdobin/STAR/archive/${STARVERSION}.tar.gz ./
ADD http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${SRAVERSION}/sratoolkit.${SRAVERSION}-ubuntu64.tar.gz ./
RUN tar zxvf sratoolkit.${SRAVERSION}-ubuntu64.tar.gz
RUN tar zxvf ${STARVERSION}.tar.gz && \
    cd STAR-${STARVERSION}/source && \
    make STAR && make clean

ENV PATH /opt/STAR-${STARVERSION}/source:/opt/sratoolkit.${SRAVERSION}-ubuntu64/bin:$PATH

# Default command
WORKDIR /data
CMD ["bash"]
