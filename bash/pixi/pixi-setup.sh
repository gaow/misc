# Install pixi
curl -fsSL https://pixi.sh/install.sh | bash

# add the pixi bin folder to your path
echo "export PATH=\$HOME/.pixi/bin:\$PATH" >> ${HOME}/.bashrc

# re-source your .bashrc in the same shell
source ${HOME}/.bashrc

# set default channels
mkdir -p ${HOME}/.config/pixi && echo 'default_channels = ["dnachun", "conda-forge", "bioconda"]' > ${HOME}/.config/pixi/config.toml

# install global packages
pixi global install <(curl -fsSL  | tr '\n' ' ')

# install R and Python libraries currently via micromamba although later pixi will also support installing them in `global` as libraries without `bin`
RUN micromamba config prepend channels nodefaults 
RUN micromamba config prepend channels bioconda
RUN micromamba config prepend channels conda-forge
RUN micromamba config prepend channels dnachun
RUN micromamba env create --yes --quiet --file <(curl -fsSL FIXME)
RUN micromamba env create --yes --quiet --file <(curl -fsSL FIXME)
RUN micromamba clean --all --yes
RUN micromamba shell init --shell=bash ${HOME}/micromamba

# Register Juypter kernels
find ${HOME}/micromamba/envs/python_libs/share/jupyter/kernels/ -maxdepth 1 -mindepth 1 -type d | \
    xargs -I % jupyter-kernelspec install %
find ${HOME}/micromamba/envs/r_libs/share/jupyter/kernels/ -maxdepth 1 -mindepth 1 -type d | \
    xargs -I % jupyter-kernelspec install %

# Set R and Python library paths 
echo '.libPaths("~/micromamba/envs/r_libs/lib/R/library")' >> $HOME/.Rprofile
echo 'export PYTHONPATH=$HOME/micromamba/envs/python_libs/lib/python3.*/site-packages' >> $HOME/.pixi/bin/juypterlab

# From now on you can install other R packages as needed with `micromamba install -n r_libs ...` and Python with `micromamba install -n python_libs ...`
