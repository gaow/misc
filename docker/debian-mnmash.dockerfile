# Docker container for ashr, mashr and mnmashr packages

# Pull base image.
FROM debian:sid-slim

# :)
MAINTAINER Gao Wang, gaow@uchicago.edu

# Install tools
WORKDIR /tmp
ENV R_BASE_VERSION 3.4.4
ENV MOSEK_VERSION 8.1.0.49
ENV GITVERSION master
ADD https://github.com/jobovy/extreme-deconvolution/archive/${GITVERSION}.tar.gz extreme-deconvolution.tar.gz
ADD https://download.mosek.com/stable/${MOSEK_VERSION}/mosektoolslinux64x86.tar.bz2 ./
RUN apt-get update -y \
    && apt-get install -qq -y --no-install-recommends \
       r-base=${R_BASE_VERSION}-* \
		   r-base-dev=${R_BASE_VERSION}-* \
		   r-recommended=${R_BASE_VERSION}-* \
       build-essential \
       libopenblas-base liblapack-base libopenblas-dev liblapack-dev \
       libgomp1
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log
##
##
RUN tar zxvf extreme-deconvolution.tar.gz \
    && cd extreme-deconvolution-${GITVERSION} \
    && make && make rpackage \
    && R CMD INSTALL ExtremeDeconvolution_1.3.tar.gz
RUN tar jxvf mosektoolslinux64x86.tar.bz2
RUN Rscript -e 'install.packages(c("Rcpp", "devtools", "mvtnorm", "rmeta", "profmem"), repos = "http://cloud.r-project.org")'
RUN Rscript -e 'install.packages("Rmosek", type="source", repos="http://download.mosek.com/R/8")' 
RUN rm -rf *

# Default command
CMD ["bash"]