#!/usr/bin/env bash

set -o errexit -o xtrace

export PIXI_HOME="${HOME}/.pixi"
export MAMBA_ROOT_PREFIX="${HOME}/micromamba"

# Use sitecustomize.py so that specific Python packages can see python_libs packages
tee ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py << EOF
import sys
sys.path[0:0] = [
    "${MAMBA_ROOT_PREFIX}/envs/python_libs/lib/python3.12/site-packages"
]
EOF

ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/jedi-language-server/lib/python3.12/site-packages/
# ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/jupyter_console/lib/python3.12/site-packages/
# ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/jupyter_core/lib/python3.12/site-packages/
# ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/jupyter_server/lib/python3.12/site-packages/
# ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/jupyterlab/lib/python3.12/site-packages/
# ln -f ${PIXI_HOME}/envs/python/lib/python3.12/site-packages/sitecustomize.py ${PIXI_HOME}/envs/sos/lib/python3.12/site-packages/

# pixi global currently gives it wrappers all lowercase names, so we need to make symlinks for R and Rscript
if [ ! -e "${HOME}/.pixi/bin/R" ]; then
  ln -sf "${HOME}/.pixi/bin/r" "${HOME}/.pixi/bin/R"
fi

if [ ! -e "${HOME}/.pixi/bin/Rscript" ]; then
  ln -sf "${HOME}/.pixi/bin/rscript" "${HOME}/.pixi/bin/Rscript"
fi

# Use Rprofile.site so that only pixi-installed R can see r_libs packages
mkdir -p ${PIXI_HOME}/envs/r-base/lib/R/etc
echo ".libPaths('${MAMBA_ROOT_PREFIX}/envs/r_libs/lib/R/library')" >> ${PIXI_HOME}/envs/r-base/lib/R/etc/Rprofile.site

# Create config files for rstudio
mkdir -p ${PIXI_HOME}/envs/rstudio/lib/R/etc
ln -f ${PIXI_HOME}/envs/r-base/lib/R/etc/Rprofile.site ${PIXI_HOME}/envs/rstudio/lib/R/etc/Rprofile.site
mkdir -p ${PIXI_HOME}/envs/rstudio/etc/rstudio
tee ${PIXI_HOME}/envs/rstudio/etc/rstudio/database.conf << EOF
directory=${HOME}/.local/var/lib/rstudio-server
EOF

tee ${PIXI_HOME}/envs/rstudio/etc/rstudio/rserver.conf << EOF
auth-none=1
database-config-file=${PIXI_HOME}/envs/rstudio/etc/rstudio/database.conf
server-daemonize=0
server-data-dir=${HOME}/.local/var/run/rstudio-server
server-user=${USER}
EOF

# Register Juypter kernels
find ${HOME}/micromamba/envs/python_libs/share/jupyter/kernels/ -maxdepth 1 -mindepth 1 -type d | \
    xargs -I % jupyter-kernelspec install --log-level=50 --user %
find ${HOME}/micromamba/envs/r_libs/share/jupyter/kernels/ -maxdepth 1 -mindepth 1 -type d | \
    xargs -I % jupyter-kernelspec install --log-level=50 --user %

# Jupyter configurations
mkdir -p $HOME/.jupyter && \
curl -s -o $HOME/.jupyter/jupyter_lab_config.py https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/configs/jupyter/jupyter_lab_config.py && \
curl -s -o $HOME/.jupyter/jupyter_server_config.py https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/configs/jupyter/jupyter_server_config.py

# VSCode configurations
mkdir -p ${HOME}/.config/code-server
curl -s -o $HOME/.config/code-server/config.yaml https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/configs/vscode/config.yaml
mkdir -p ${HOME}/.local/share/code-server/User
curl -s -o $HOME/.local/share/code-server/User/settings.json https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/configs/vscode/settings.json

code-server --install-extension ms-python.python
code-server --install-extension ms-toolsai.jupyter
code-server --install-extension reditorsupport.r
code-server --install-extension rdebugger.r-debugger
code-server --install-extension ionutvmi.path-autocomplete
code-server --install-extension usernamehw.errorlens
