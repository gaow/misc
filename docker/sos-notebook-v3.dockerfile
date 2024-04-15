# https://github.com/jupyter/docker-stacks/blob/f3079808ca8cf7a0520a0845fb954e1866913942/base-notebook/Dockerfile
FROM jupyter/base-notebook:hub-3.1.1

MAINTAINER Gao Wang <wang.gao@columbia.edu>


RUN mamba install -y -c conda-forge \
  bash_kernel \
  feather-format \
  imageio \
  jupyter_contrib_nbextensions \
  jupyterlab=3.6 \
  jupyter_server=1.23.6 \
  jupyter_client=8.0.3 \
  jupyter-lsp \
  jupyterlab-sos \
  markdown \
  markdown-kernel \
  nbdime \
  nbformat \
  notebook=6.5.4 \
  pillow \
  r-base>4 \
  r-irkernel \
  r-languageserver \
  ipykernel \
  sos \
  sos-bash \
  sos-notebook \
  sos-pbs \
  sos-python \
  wand && mamba clean --all -f -y
RUN mamba install -y -c conda-forge r-dplyr r-stringr r-readr r-magrittr r-data.table r-ggplot2 r-cowplot r-remotes && \
    mamba clean --all -f -y

# https://stat.ethz.ch/R-manual/R-devel/library/base/html/Startup.html
# If you want ‘~/.Renviron’ or ‘~/.Rprofile’ to be ignored by child R processes (such as those run by R CMD check and R CMD build), set the appropriate environment variable R_ENVIRON_USER or R_PROFILE_USER to (if possible, which it is not on Windows) "" or to the name of a non-existent file.
ENV R_ENVIRON_USER ""
ENV R_PROFILE_USER ""
ENV R_LIBS_USER " "

## To build for multiple platforms, 
# docker buildx create --use && docker buildx build --push --tag gaow/sos-notebook:3.1.1 --platform=linux/arm64,linux/amd64 -f sos-notebook-v3.dockerfile .
# docker push gaow/sos-notebook:3.1.1