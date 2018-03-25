# Docker container for NGS tools mostly from Debian official repo 
# - apt-get install tabix samtools bedtools
# - SRAToolKit 2.9.0 developed by NCBI Genbank/SRA team.

# Pull base image.
FROM debian:stable-slim

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# clone repo
WORKDIR /src
ENV SRAVERSION 2.9.0
RUN apt-get update -y && apt-get install -yq --no-install-recommends \
    wget tabix bgzip samtools bedtools \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget "http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${SRAVERSION}/sratoolkit.${SRAVERSION}-ubuntu64.tar.gz" && \
    tar zxfv sratoolkit.${SRAVERSION}-ubuntu64.tar.gz && \
    cp -r sratoolkit.${SRAVERSION}-ubuntu64/bin/* /usr/bin

# Default command
WORKDIR /data
CMD ["bash"]
