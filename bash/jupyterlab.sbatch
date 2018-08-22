#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --partition=broadwl
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=2000
#SBATCH --job-name=nb-tunnel
#SBATCH --output=nb-log-%J.out
#SBATCH --error=nb-log-%J.err

ipnport=$(shuf -i8000-9999 -n1)
ipnip=$(hostname -i)
login=midway.rcc.uchicago.edu

# These will be written to `nb-log-%J.out`
echo -e "\n\n   Copy/Paste this in your local terminal to ssh tunnel with
remote   "
echo        "   \`\`\`bash
"
echo        "   ssh -N -L $ipnport:$ipnip:$ipnport $USER@$login -v
"
echo        "   \`\`\`
"
echo -e "\n\n   Then open a browser on your local machine to the following
address "
echo        "   \`\`\`google-chrome
"
echo        "   localhost:$ipnport
"
echo -e     "   \`\`\`\n\n"
echo        " You may be asked to provide a token. Please find it in the `nb-log-*.err` file
"
sleep 1
# Start jupyter
cd
jupyter-lab --no-browser --port=$ipnport --ip=$ipnip

# Then follow instructions above.
