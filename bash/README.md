# Useful bash scripts

## JupyterLab server on cluster via SSH tunnel

Tested on UChicago RCC. 

1. Edit `jupyterlab.sbatch` to update the JupyterLab session resource. Current setup is that the server will be created on partition `broadwl`, 1 node, 1 CPU, 2G memory and is good for 24 hours.
2. Submit the job script from the login node
```bash
sbatch jupyterlab.sbatch
```
3. Wait for the job to get started. That is, you should find a non-empty `nb-log-{jobid}.err` file yet does not contain any errors. That should indicate your server is up and running. Only until then can you attempt to connect to it. For example:

```bash
cat nb-log-{jobid}.err
```
```
[I 11:26:07.126 NotebookApp] Serving notebooks from local directory: /home/gaow
[I 11:26:07.126 NotebookApp] 0 active kernels 
[I 11:26:07.126 NotebookApp] The Jupyter Notebook is running at: http:// ...
```
4. After the server starts, you should see under the directory the log file of the job you just submitted:

```bash
cat nb-log-{jobid}.out
```

It should read like:

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

Just follow the prompts: run `ssh -N -L ...` command on your **local computer**, then open  your faviorate web browser, eg, `google-chrome`, on your **local computer** and type in `localhost: ...` in the address bar.

4. The browser window will prompt you to type an access `token` to it. The information is in `nb-log-{jobid}.err`. 
In that file you should see a line that says:

```
Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://<ip:port>/?token=xxxxxxxxxxxxxxxxxx
```
Copy & paste the token part `xxxxx` to the dialog box on your browser asking for the token, hit "enter", you should be directed to the Jupyter Lab server you created a moment ago.
5. To shut down the server, simply cancel the job
```
qdel {jobid}
```
