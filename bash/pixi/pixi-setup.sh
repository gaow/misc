set -euo pipefail
# Determine the current shell
if [ -z "$ZSH_VERSION" ]; then
  # Zsh shell
  CONFIG_FILE="${HOME}/.zshrc"
elif [ -z "$BASH_VERSION" ]; then
  # Bash shell
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    CONFIG_FILE="${HOME}/.bashrc"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    CONFIG_FILE="${HOME}/.bash_profile"
  fi
else
  echo "Unsupported shell. Please use bash or zsh."
  exit 1
fi

echo "Configuration file ${CONFIG_FILE} will be modified by this script."

# Install pixi
if ! command -v pixi &> /dev/null
then
    # Install Pixi
    curl -fsSL https://pixi.sh/install.sh | bash
        
    if ! grep -q 'export PATH="${HOME}/.pixi/bin:${PATH}"' "${CONFIG_FILE}"; then
        echo 'export PATH="${HOME}/.pixi/bin:${PATH}"' >> "${CONFIG_FILE}"
        export PATH="${HOME}/.pixi/bin:${PATH}"
    fi
else
    echo "Pixi is already installed."
fi

# Configure shell

if ! grep -q 'unset PYTHONPATH' "${CONFIG_FILE}"; then
  echo "unset PYTHONPATH" >> "${CONFIG_FILE}"
  unset PYTHONPATH
fi

if ! grep -q 'export PYDEVD_DISABLE_FILE_VALIDATION=1' "${CONFIG_FILE}"; then
  echo "export PYDEVD_DISABLE_FILE_VALIDATION=1" >> "${CONFIG_FILE}"
  export PYDEVD_DISABLE_FILE_VALIDATION=1
fi

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
