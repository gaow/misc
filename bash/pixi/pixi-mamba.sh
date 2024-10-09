set -euo pipefail

export PIXI_HOME="${HOME}/.pixi"
export MAMBA_ROOT_PREFIX="${HOME}/micromamba"

# Install pixi
curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/pixi-setup.sh | bash

# Install global packages
curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/envs/global_packages.txt | grep -v "#" | xargs -I % bash -c "pixi global install %"
pixi clean cache -y

# install R and Python libraries currently via micromamba although later pixi will also support installing them in `global` as libraries without `bin`
# NOTE: This is assuming a first-time run
if [ -n ${HOME}/micromamba/envs/etc ]; then
    rm -rf ${HOME}/micromamba/etc
fi
micromamba config prepend channels nodefaults
micromamba config prepend channels bioconda
micromamba config prepend channels conda-forge
micromamba config prepend channels dnachun
micromamba shell init --quiet --shell=bash ${HOME}/micromamba

if [ -n ${HOME}/micromamba/envs/etc ]; then
    rm -rf ${HOME}/micromamba/etc
fi

rm -rf ${HOME}/.mambarc
echo "use_lockfiles: false" >> ${HOME}/.mambarc

echo "Installing recommended R libraries ..."
curl -s -O https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/envs/r.yml && micromamba env create --yes --quiet --file r.yml && rm -f r.yml
echo "Installing recommended Python packages ..."
curl -s -O https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/envs/python.yml && micromamba env create --yes --quiet --file python.yml && rm -f python.yml
micromamba clean --all --yes

# fix R and Python settings 
curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/init.sh | bash

# print messages
BB='\033[1;34m'
NC='\033[0m'
echo -e "${BB}Installation completed.${NC}"
echo -e "${BB}Note: From now on you can install other R packages as needed with 'micromamba install -n r_libs ...'${NC}"
echo -e "${BB}and Python with 'micromamba install -n python_libs ...'${NC}"
