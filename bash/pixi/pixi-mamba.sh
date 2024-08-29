set -euo pipefail
# Install pixi
curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/pixi-setup.sh | bash 

# Install global packages
pixi global install $(curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/global_packages.txt | tr '\n' ' ')

# install R and Python libraries currently via micromamba although later pixi will also support installing them in `global` as libraries without `bin`
micromamba config prepend channels nodefaults 
micromamba config prepend channels bioconda
micromamba config prepend channels conda-forge
micromamba config prepend channels dnachun
micromamba shell init --shell=bash ${HOME}/micromamba
# NOTE: This is assuming a first-time run
if [ -n ${HOME}/micromamba/envs/etc ]; then
    rm -rf ${HOME}/micromamba/etc
fi

curl -O https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/r.yml && micromamba env create --yes --file r.yml && rm -f r.yml
curl -O https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/python.yml && micromamba env create --yes --file python.yml && rm -f python.yml
micromamba clean --all --yes

# fix R and Python settings 
curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/init.sh | bash

# print messages
BB='\033[1;34m'
NC='\033[0m'
echo -e "${BB}Installation completed.${NC}"
echo -e "${BB}Note: From now on you can install other R packages as needed with 'micromamba install -n r_libs ...'${NC}"
echo -e "${BB}and Python with 'micromamba install -n python_libs ...'${NC}"
