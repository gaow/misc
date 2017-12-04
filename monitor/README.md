## `monitor.py`

It is a Python wrapper to system command calls that recursively checks memory usage every 2 seconds and report the peak usage at the end of execution:

```
$ ./monitor.py R --slave -e "x = runif(1E2)"
return code: 0
memory check interval: 1.0s
time: 0.54s
peak first occurred: 0.00s
peak last occurred: 0.00s
max vms_memory: 0.13GB
max rss_memory: 0.01GB

$ ./monitor.py R --slave -e "x = runif(1E4)"
return code: 0
memory check interval: 1.0s
time: 0.54s
peak first occurred: 0.00s
peak last occurred: 0.00s
max vms_memory: 0.13GB
max rss_memory: 0.01GB

$ ./monitor.py R --slave -e "x = runif(1E8)"
return code: 0
memory check interval: 1.0s
time: 4.75s
peak first occurred: 1.04s
peak last occurred: 4.19s
max vms_memory: 1.27GB
max rss_memory: 0.88GB

$ ./monitor.py R --slave -e "x = runif(1E9)"
return code: 0
memory check interval: 1.0s
time: 38.73s
peak first occurred: 1.05s
peak last occurred: 38.17s
max vms_memory: 8.98GB
max rss_memory: 8.53GB
```

The check interval can be changed via:
```
$ export MEM_CHECK_INTERVAL=0.4
$ ./monitor.py R --slave -e "x = runif(1E4)"
return code: 0
memory check interval: 0.4s
time: 0.24s
peak first occurred: 0.00s
peak last occurred: 0.00s
max vms_memory: 0.13GB
max rss_memory: 0.01GB
```

To use on Uchicago RCC, you need to `module load python/3.5.2`. If the test command above does
not work with error message `psutil not found` you then need to install that module:

```
pip install --user psutil
```
