# Determine the current shell
if [ -v ZSH_VERSION ]; then
  # Zsh shell
  CONFIG_FILE="${HOME}/.zshrc"
elif [ -v BASH_VERSION ]; then
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
