# Useful bash scripts

## JupyterLab server on cluster via SSH tunnel

Tested on UChicago RCC. 

1. Edit `jupyterlab.sbatch` to update the JupyterLab session resource. Current setup is that the server is on partition `broadwl`, is good for 24 hours, uses one node, 1 CPU and 2G memory.
2. Submit the job script, eg, `sbatch jupyterlab.sbatch`.
3. Wait for the job to get started. After it starts you should see under the directory you submit the job a file called `nb-log-*.out`, with contents like:

```
   Copy & paste the following to your local computer's terminal to tunnel 
to the remote server:

   ssh -N -L 9279:10.50.221.17:9279 <your username>@<the remote url> -v

   Then use a web browser on your local computer to open the following
address:
 
   localhost:9279

   You may be asked to provide a token (a string of 48 letters + digits). 
Please find it in the `nb-log-*.err` file under your current directory.
```

Just follow the prompts: run `ssh -N -L ...` command on your **local computer**, then open a browser on your **local computer** and visit `localhost: ...`.

4. You will be asked for a "token". You should see a file called `nb-log-*.err`. It will contain the information. Copy & paste it to the dialog box it ask for the token, hit "enter", you should be directed to the Jupyter Lab server you created a moment ago.
