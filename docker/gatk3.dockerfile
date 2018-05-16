FROM anapsix/alpine-java:8

MAINTAINER Gao Wang, gaow@uchicago.edu

WORKDIR /tmp
ENV version 3.8-0
RUN apk add --no-cache curl
RUN curl -L \
    https://github.com/Miachol/gatk_releases/raw/master/gatk${version}.tar.gz -o gatk.tar.gz \
    && tar -xzvf gatk.tar.gz \
    && mv gatk${version}/GenomeAnalysisTK.jar /opt \
    && chmod 644 /opt/GenomeAnalysisTK.jar \
    && rm -rf *

# Default command
CMD ["bash"]
