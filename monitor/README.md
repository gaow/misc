## `monitor.py`

It is a Python wrapper to system command calls that recursively checks memory usage every 2 seconds and report it at the end of execution:

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
```
