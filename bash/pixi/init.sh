#!/usr/bin/env bash

set -o errexit -o xtrace

# Only show PYTHONPATH and R_LIBS to specific executables
export PIXI_HOME="${HOME}/.pixi"
export MAMBA_ROOT_PREFIX="${HOME}/micromamba"

tee ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py << EOF
import sys
sys.path[0:0] = [
    "${MAMBA_ROOT_PREFIX}/envs/python_libs/lib/python3.12/site-packages"
]
EOF

ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/jupyter_client/lib/python3.12/site-packages/
ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/jupyter_console/lib/python3.12/site-packages/
ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/jupyter_core/lib/python3.12/site-packages/
ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/jupyter_server/lib/python3.12/site-packages/
ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/jupyterlab/lib/python3.12/site-packages/
ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/sos/lib/python3.12/site-packages/

mkdir -p ${PIXI_HOME}/envs/r-base/lib/R/etc
echo ".libPaths('${MAMBA_ROOT_PREFIX}/envs/r_libs/lib/R/library')" >> ${PIXI_HOME}/envs/r-base/lib/R/etc/Rprofile.site

# pixi global currently gives it wrappers all lowercase names, so we need to make symlinks for R and Rscript
if [ ! -e "${HOME}/.pixi/bin/R" ]; then
  ln -sf "${HOME}/.pixi/bin/r" "${HOME}/.pixi/bin/R"
fi

if [ ! -e "${HOME}/.pixi/bin/Rscript" ]; then
  ln -sf "${HOME}/.pixi/bin/rscript" "${HOME}/.pixi/bin/Rscript"
fi

# Register Juypter kernels
find ${HOME}/micromamba/envs/python_libs/share/jupyter/kernels/ -maxdepth 1 -mindepth 1 -type d | \
    xargs -I % jupyter-kernelspec install --user %
find ${HOME}/micromamba/envs/r_libs/share/jupyter/kernels/ -maxdepth 1 -mindepth 1 -type d | \
    xargs -I % jupyter-kernelspec install --user %

# Jupyter configurations
mkdir -p $HOME/.jupyter && \
curl -o $HOME/.jupyter/jupyter_lab_config.py https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/jupyter_lab_config.py && \
curl -o $HOME/.jupyter/jupyter_server_config.py https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/jupyter_server_config.py
