# Only show PYTHONPATH and R_LIBS to specific executables
sed -i '2i export PYTHONPATH="${HOME}/micromamba/envs/python_libs/lib/python3.12/site-packages"' ${HOME}/.pixi/bin/python
sed -i '2i export PYTHONPATH="${HOME}/micromamba/envs/python_libs/lib/python3.12/site-packages"' ${HOME}/.pixi/bin/python3
sed -i '2i export PYTHONPATH="${HOME}/micromamba/envs/python_libs/lib/python3.12/site-packages"' ${HOME}/.pixi/bin/jupyter-lab
sed -i '2i export PYTHONPATH="${HOME}/micromamba/envs/python_libs/lib/python3.12/site-packages"' ${HOME}/.pixi/bin/jupyter-server
echo "unset PYTHONPATH" >> ${HOME}/.bashrc

echo '.libPaths("~/micromamba/envs/r_libs/lib/R/library")' >> ${HOME}/.Rprofile

# pixi global currently gives it wrappers all lowercase names, so we need to make symlinks for R and Rscript
ln -sf ${HOME}/.pixi/bin/r ${HOME}/.pixi/bin/R
ln -sf ${HOME}/.pixi/bin/rscript ${HOME}/.pixi/bin/Rscript

