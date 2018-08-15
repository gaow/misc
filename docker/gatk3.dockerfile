FROM anapsix/alpine-java:8

MAINTAINER Gao Wang, gaow@uchicago.edu

WORKDIR /tmp
RUN apk add --no-cache curl

ENV gatk_version 3.8-0
RUN curl -L \
    https://github.com/Miachol/gatk_releases/raw/master/gatk${gatk_version}.tar.gz -o gatk.tar.gz \
    && tar -xzvf gatk.tar.gz \
    && mv gatk${gatk_version}/GenomeAnalysisTK.jar /opt \
    && chmod 644 /opt/GenomeAnalysisTK.jar \
    && rm -rf *

ENV picard_version 2.18.11
RUN curl -L https://github.com/broadinstitute/picard/releases/download/${picard_version}/picard.jar -o /opt/picard.jar \
    && chmod 644 /opt/picard.jar


# Default command
CMD ["bash"]
