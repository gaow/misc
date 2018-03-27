# Add GATK4 and PICARD to debian-ngs

FROM gaow/debian-ngs:latest

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install tools
WORKDIR /tmp
ENV GITVERSION master

# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN mkdir -p /usr/share/man/man1
RUN apt-get update -y \
    && apt-get install -yq --no-install-recommends \
    default-jdk ca-certificates-java python3 r-base git git-lfs \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /opt/ngs
RUN git clone --depth 1 https://github.com/broadinstitute/gatk.git \
    && cd gatk \
    && ./gradlew localJar \
    && Rscript scripts/docker/gatkbase/install_R_packages.R \
    && mv build/libs/gatk.jar /opt
RUN git clone --depth 1 https://github.com/broadinstitute/picard.git \
    && cd picard \
    && ./gradlew shadowJar \
    && mv build/libs/picard.jar /opt/ngs
RUN rm -rf *

ENV CLASSPATH /opt/ngs:CLASSPATH

# Default command
CMD ["bash"]
