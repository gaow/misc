## `monitor.py`

It is a Python wrapper to system command calls that recursively checks memory usage at specified intervals (default every 1 second) and report the peak usage at the end of execution:

```
$ ./monitor.py R --slave -e "x = runif(1E2)"

time elapsed: 0.40s
peak first occurred: 0.29s
peak last occurred: 0.29s
max vms_memory: 0.33GB
max rss_memory: 0.05GB
memory check interval: 0.1s
return code: 0

$ ./monitor.py R --slave -e "x = runif(1E4)"

time elapsed: 0.42s
peak first occurred: 0.31s
peak last occurred: 0.31s
max vms_memory: 0.34GB
max rss_memory: 0.05GB
memory check interval: 0.1s
return code: 0

$ ./monitor.py R --slave -e "x = runif(1E8)"

time elapsed: 4.42s
peak first occurred: 0.45s
peak last occurred: 4.32s
max vms_memory: 1.27GB
max rss_memory: 0.91GB
memory check interval: 0.1s
return code: 0

$ ./monitor.py R --slave -e "x = runif(1E9)"

time elapsed: 39.09s
peak first occurred: 0.45s
peak last occurred: 38.68s
max vms_memory: 8.98GB
max rss_memory: 8.61GB
memory check interval: 0.1s
return code: 0
```

The check interval can be changed via:
```
$ export MEM_CHECK_INTERVAL=2
$ ./monitor.py R --slave -e "x = runif(1E9)"

time elapsed: 40.21s
peak first occurred: 2.05s
peak last occurred: 39.15s
max vms_memory: 8.98GB
max rss_memory: 8.61GB
memory check interval: 2.0s
return code: 0
```

To use on Uchicago RCC, you need to `module load python/3.5.2`. If the test command above does
not work with error message `psutil not found` you then need to install that module:

```
pip install --user psutil
```

## Overhead

The time it takes to run a command directly from shell is:

```
$ time R --slave -e "x = runif(1E9)"

real	0m38.996s
user	0m35.692s
sys	0m3.236s
```

which is 38.99s compared to the elapsed 39.09s when memory check is performed at every 0.1s interval. So the overhead of this program should be minimal.
