## `monitor.py`

It is a Python wrapper to system command calls that recursively checks memory usage every 2 seconds and report the peak usage at the end of execution:

```
[GW] ./monitor.py R --slave -e "x = runif(1E2)"
return code: 0
time: 0.51s
max_vms_memory: 0.12GB
max_rss_memory: 0.01GB
[GW] ./monitor.py R --slave -e "x = runif(1E4)"
return code: 0
time: 0.51s
max_vms_memory: 0.12GB
max_rss_memory: 0.01GB
[GW] ./monitor.py R --slave -e "x = runif(1E8)"
return code: 0
time: 3.08s
max_vms_memory: 1.18GB
max_rss_memory: 0.76GB
[GW] python monitor.py R --slave -e "x = runif(1E9)"
return code: 0
time: 26.72s
max_vms_memory: 8.97GB
max_rss_memory: 8.39GB
```

To use on Uchicago RCC, you need to `module load python/3.5.2`. If the test command above does
not work with error message `psutil not found` you then need to install that module:

```
pip install psutil
```
