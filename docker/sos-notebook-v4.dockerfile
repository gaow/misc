FROM jupyter/base-notebook:hub-4.0.2

MAINTAINER Gao Wang <wang.gao@columbia.edu>

ARG CONDAENV=pisces-rabbit

COPY ${CONDAENV}.yml /tmp
RUN mamba env create -y -f /tmp/${CONDAENV}.yml && \
    mamba activate ${CONDAENV} && \
    mamba install -y r-dplyr r-stringr r-readr r-magrittr r-data.table r-ggplot2 r-cowplot r-remotes && \
    mamba clean --all -f -y

# https://stat.ethz.ch/R-manual/R-devel/library/base/html/Startup.html
# If you want ‘~/.Renviron’ or ‘~/.Rprofile’ to be ignored by child R processes (such as those run by R CMD check and R CMD build), set the appropriate environment variable R_ENVIRON_USER or R_PROFILE_USER to (if possible, which it is not on Windows) "" or to the name of a non-existent file.
ENV R_ENVIRON_USER ""
ENV R_PROFILE_USER ""
ENV R_LIBS_USER " "

## To build for multiple platforms, 
# docker buildx create --use && docker buildx build --push --tag gaow/sos-notebook:4.0.2 --platform=linux/arm64,linux/amd64 -f sos-notebook-v4.dockerfile .
# docker push gaow/sos-notebook:4.0.2