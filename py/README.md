# Random Python scripts

## `monitor.py`

It is a Python wrapper to system command calls that recursively checks memory usage every 2 seconds and report it at the end of execution:

```
[GW] ./monitor.py R --slave -e "x = runif(1E2)"
return code: 0
time: 0.514854907989502
max_vms_memory (GB): 0.12
max_rss_memory (GB): 0.01
[GW] ./monitor.py R --slave -e "x = runif(1E4)"
return code: 0
time: 0.5150308609008789
max_vms_memory (GB): 0.12
max_rss_memory (GB): 0.01
[GW] ./monitor.py R --slave -e "x = runif(1E8)"
return code: 0
time: 3.0810322761535645
max_vms_memory (GB): 1.18
max_rss_memory (GB): 0.76
```
