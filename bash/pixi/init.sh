#!/usr/bin/env bash
set -o errexit -o xtrace

# Use sitecustomize.py so that specific Python packages can see python_libs packages
if [ -d "/mnt/efs" ]; then
   if [[ ! -f ${HOME}/.local/lib/python3.12/site-packages/sitecustomize.py ]]; then
      mkdir -p ${HOME}/.local/lib/python3.12/site-packages
      tee ${HOME}/.local/lib/python3.12/site-packages/sitecustomize.py << EOF
import sys
sys.path[0:0] = [
   "/mnt/efs/shared/.pixi/envs/python/lib/python3.12/site-packages"
]
EOF
   fi
   if [[ ! -f ${HOME}/.Rprofile ]]; then
      echo ".libPaths('/mnt/efs/shared/.pixi/envs/r-base/lib/R/library')" >> ${HOME}/.Rprofile
   fi
fi

# Use Rprofile.site so that only pixi-installed R can see r-base packages
if [[ ! -f ${HOME}/.pixi/envs/python/lib/R/etc/Rprofile.site ]]; then
   mkdir -p ${HOME}/.pixi/envs/python/lib/R/etc
   echo ".libPaths('${HOME}/.pixi/envs/r-base/lib/R/library')" >> ${HOME}/.pixi/envs/python/lib/R/etc/Rprofile.site
fi

# Create config files for rstudio
if [[ ! -f ${HOME}/.config/rstudio/database.conf ]]; then
   mkdir -p ${HOME}/.config/rstudio
   tee ${HOME}/.config/rstudio/database.conf << EOF
directory=${HOME}/.local/var/lib/rstudio-server
EOF
fi

if [[ ! -f ${HOME}/.config/rstudio/rserver.conf ]]; then
   tee ${HOME}/.config/rstudio/rserver.conf << EOF
rsession-which-r=${HOME}/.pixi/envs/r-base/bin/R
auth-none=1
database-config-file=${HOME}/.config/rstudio/database.conf
server-daemonize=0
server-data-dir=${HOME}/.local/var/run/rstudio-server
server-user=${USER}
EOF
fi

# Register Juypter kernels
if [[ -d ${HOME}/.pixi/envs/python/share/jupyter/kernels/ ]]; then
   find ${HOME}/.pixi/envs/python/share/jupyter/kernels/ -maxdepth 1 -mindepth 1 -type d | \
      xargs -I % jupyter-kernelspec install --log-level=50 --user %
   find ${HOME}/.pixi/envs/r-base/share/jupyter/kernels/ -maxdepth 1 -mindepth 1 -type d | \
      xargs -I % jupyter-kernelspec install --log-level=50 --user %
   # ark --install
fi

# Jupyter configurations
if [[ ! -f $HOME/.jupyter/jupyter_lab_config.py ]] && [[ ! -f $HOME/.jupyter/jupyter_server_config.py ]]; then
   mkdir -p $HOME/.jupyter && \
   curl -s -o $HOME/.jupyter/jupyter_lab_config.py https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/configs/jupyter/jupyter_lab_config.py && \
   curl -s -o $HOME/.jupyter/jupyter_server_config.py https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/configs/jupyter/jupyter_server_config.py
fi

# VSCode configurations
if [[ ! -f $HOME/.config/code-server/config.yaml ]] && [[ ! -f $HOME/.local/share/code-server/User/settings.json ]]; then
   mkdir -p ${HOME}/.config/code-server
   curl -s -o $HOME/.config/code-server/config.yaml https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/configs/vscode/config.yaml
   mkdir -p ${HOME}/.local/share/code-server/User
   curl -s -o $HOME/.local/share/code-server/User/settings.json https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/configs/vscode/settings.json
fi

if ! command -v code-server &> /dev/null; then
   echo "WARNING: code-server is not installed."
else
   code-server --install-extension ms-python.python
   code-server --install-extension ms-toolsai.jupyter
   code-server --install-extension reditorsupport.r
   code-server --install-extension rdebugger.r-debugger
   code-server --install-extension ionutvmi.path-autocomplete
   code-server --install-extension usernamehw.errorlens
fi

# Temporary fix to run post-link scripts
if [[ -d ${HOME}/.pixi/envs/r-base/bin ]]; then
   find ${HOME}/.pixi/envs/r-base/bin -name '*bioconductor-*-post-link.sh' | \
   xargs -I % bash -c "PREFIX=${HOME}/.pixi/envs/r-base PATH=${HOME}/.pixi/envs/r-base/bin:${PATH} %"
fi