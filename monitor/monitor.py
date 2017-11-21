#!/usr/bin/env python3
# Copyright (c) 2012 Realz Slaw, 2017 Gao Wang
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import sys
import time
import psutil
import subprocess

class ProcessTimer:
  def __init__(self,command):
    self.command = command
    self.execution_state = False
    self.interval = 1

  def execute(self):
    self.max_vms_memory = 0
    self.max_rss_memory = 0

    self.t1 = None
    self.t0 = time.time()
    self.p = subprocess.Popen(self.command, shell=False)
    self.execution_state = True

  def poll(self):
    if not self.check_execution_state():
      return False

    self.t1 = time.time()

    try:
      pp = psutil.Process(self.p.pid)

      #obtain a list of the subprocess and all its descendants
      descendants = list(pp.children(recursive=True))
      descendants = descendants + [pp]

      rss_memory = 0
      vms_memory = 0

      #calculate and sum up the memory of the subprocess and all its descendants 
      for descendant in descendants:
        try:
          mem_info = descendant.memory_info()

          rss_memory += mem_info[0]
          vms_memory += mem_info[1]
        except psutil.NoSuchProcess:
          #sometimes a subprocess descendant will have terminated between the time
          # we obtain a list of descendants, and the time we actually poll this
          # descendant's memory usage.
          pass
      self.max_vms_memory = max(self.max_vms_memory,vms_memory)
      self.max_rss_memory = max(self.max_rss_memory,rss_memory)

    except psutil.NoSuchProcess:
      return self.check_execution_state()

    return self.check_execution_state()

  def is_running(self):
    return psutil.pid_exists(self.p.pid) and self.p.poll() == None
  
  def check_execution_state(self):
    if not self.execution_state:
      return False
    if self.is_running():
      return True
    self.executation_state = False
    self.t1 = time.time()
    return False

  def close(self,kill=False):
    try:
      pp = psutil.Process(self.p.pid)
      if kill:
        pp.kill()
      else:
        pp.terminate()
    except psutil.NoSuchProcess:
      pass

def takewhile_excluding(iterable, value = ['|', '<', '>']):
    for it in iterable:
        if it in value:
            return
        yield it

if len(sys.argv) <= 1:
  sys.exit()
ptimer = ProcessTimer(takewhile_excluding(sys.argv[1:]))

try:
  ptimer.execute()
  #poll as often as possible; otherwise the subprocess might
  # "sneak" in some extra memory usage while you aren't looking
  while ptimer.poll():
    time.sleep(ptimer.interval)
finally:
  #make sure that we don't leave the process dangling?
  ptimer.close()

sys.stderr.write('return code: %s\n' % ptimer.p.returncode)
sys.stderr.write('time: {:.2f}s\n'.format(max(0, ptimer.t1 - ptimer.t0 - ptimer.interval * 0.5)))
sys.stderr.write('max_vms_memory: {:.2f}GB\n'.format(ptimer.max_vms_memory * 1.07E-9))
sys.stderr.write('max_rss_memory: {:.2f}GB\n'.format(ptimer.max_rss_memory * 1.07E-9))
