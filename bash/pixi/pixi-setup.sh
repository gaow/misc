set -euo pipefail

export PIXI_HOME="${HOME}/.pixi"

# Install pixi
curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/pixi-install.sh | bash

# Install global packages
pixi global install $(curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/envs/global_packages.txt | grep -v "#" | tr '\n' ' ')
pixi global expose remove kill
pixi global install coreutils
pixi global expose remove kill uptime
pixi global install procps-ng
pixi clean cache -y


echo "Installing recommended R libraries ..."
pixi global install --environment r-base $(curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/envs/r_packages.txt | grep -v "#" | tr '\n' ' ')
echo "Installing recommended Python packages ..."
pixi global install --environment python $(curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/envs/python_packages.txt | grep -v "#" | tr '\n' ' ')
pixi clean cache -y

# Install config files
curl -fsSL https://raw.githubusercontent.com/gaow/misc/master/bash/pixi/init.sh | bash

# print messages
BB='\033[1;34m'
NC='\033[0m'
echo -e "${BB}Installation completed.${NC}"
echo -e "${BB}Note: From now on you can install other R packages as needed with 'pixi global install --environment r-base ...'${NC}"
echo -e "${BB}and Python with 'pixi global install --environment python ...'${NC}"
