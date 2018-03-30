# Docker container for NGS tools mostly from Debian official repo 
# - apt-get install tabix bwa bowtie2 tophat samtools bedtools
# - github master: STAR, bcftools
# - SRAToolKit 2.8.2-1 developed by NCBI Genbank/SRA team.

# Pull base image.
FROM debian:stable-slim

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install tools
WORKDIR /data
ENV SRAVERSION 2.8.2-1
ENV GITVERSION master
RUN apt-get update -y \
    && apt-get install -qq -y --no-install-recommends \
    tabix bwa bowtie2 tophat samtools bedtools \
    build-essential zlib1g-dev libbz2-dev liblzma-dev \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log
ADD http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${SRAVERSION}/sratoolkit.${SRAVERSION}-ubuntu64.tar.gz ./
ADD https://github.com/alexdobin/STAR/archive/${GITVERSION}.tar.gz STAR.tar.gz
ADD https://github.com/samtools/htslib/archive/${GITVERSION}.tar.gz htslib.tar.gz
ADD https://github.com/samtools/bcftools/archive/${GITVERSION}.tar.gz bcftools.tar.gz
RUN tar zxvf sratoolkit.${SRAVERSION}-ubuntu64.tar.gz \
    && mv sratoolkit.${SRAVERSION}-ubuntu64/bin/* /usr/local/bin
RUN tar zxvf STAR.tar.gz \
    && cd STAR-${GITVERSION}/source \
    && make STAR \
    && mv STAR /usr/local/bin
RUN tar zxvf htslib.tar.gz \
    && mv htslib-${GITVERSION} htslib \
    && tar zxvf bcftools.tar.gz \
    && mv bcftools-${GITVERSION} bcftools \
    && cd bcftools \
    && make \
    && make install
RUN rm -rf *

# Default command
CMD ["bash"]
