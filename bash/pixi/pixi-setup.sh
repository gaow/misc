# Install pixi
curl -fsSL https://pixi.sh/install.sh | bash

# add the pixi bin folder to your path
echo "export PATH=\$HOME/.pixi/bin:\$PATH" >> ${HOME}/.bashrc

# re-source your .bashrc in the same shell
source ${HOME}/.bashrc

# set default channels
mkdir -p ${HOME}/.config/pixi && echo 'default_channels = ["dnachun", "conda-forge", "bioconda"]' > ${HOME}/.config/pixi/config.toml

# install global packages
pixi global install $(curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/global_packages.txt | tr '\n' ' ')

# install R and Python libraries currently via micromamba although later pixi will also support installing them in `global` as libraries without `bin`
micromamba config prepend channels nodefaults 
micromamba config prepend channels bioconda
micromamba config prepend channels conda-forge
micromamba config prepend channels dnachun
micromamba shell init --shell=bash ${HOME}/micromamba
curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/r.yml && micromamba env create --yes --file r.yml && rm -f r.yml
curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/python.yml && micromamba env create --yes --file python.yml && rm -f python.yml
micromamba clean --all --yes

# fix R and Python settings 
curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/init.sh | bash

# From now on you can install other R packages as needed with `micromamba install -n r_libs ...` 
# and Python with `micromamba install -n python_libs ...`
