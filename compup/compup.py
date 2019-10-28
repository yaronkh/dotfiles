#!/usr/bin/env python

import sys
import os
import re
from select import select
import subprocess
import time
import psutil

def get_win_index():
    p = os.getppid()
    pane_list = subprocess.check_output(['tmux','list-panes','-a','-F',"#{pane_pid} #{window_index}"])[:-1].split('\n')
    while p != 1:
        for l in pane_list:
            pid, id = l.split(' ')
            if int(pid, 10) == p:
                return str(id)
        p = psutil.Process(p).ppid()
    print ("!!!!CANOT GET WIN INDX")
    return -1

def restore_tab_name(indx):
  os.system("tmux set -t " + str(indx) + " automatic-rename")

def set_tab_name(indx, line):
  os.system("tmux rename-window -t " + str(indx) + " \"" + line + "\"")


comp_line = re.compile("^\[ *([^\]]+)\].*")
win_index = get_win_index()
os.system("tmux rename-window -t " + win_index + " comp")
t = time.time() - 1
ttab = time.time()
last_line = ""
new_line = ""

def process_new_line():
  global t, new_line, last_line, win_index
  line = sys.stdin.readline()
  if line == "":
     return -1
  print line[:-1]
  comp_line_res = comp_line.match(line)
  if comp_line_res == None:
     return 0
  new_line = comp_line_res.groups(1)[0]
  return 0

try:
  while (True):
      rlist, _, _ = select([sys.stdin], [], [], 1)
      if rlist:
          res = process_new_line()
          if res < 0:
              break
      if (time.time() - t) >= 1.0 and last_line != new_line:
          t = time.time()
          last_line = new_line
          set_tab_name(win_index, new_line)
      if (time.time() - ttab) >= 1.0:
          ttab = time.time()
          new_win_index = get_win_index()
          if new_win_index != win_index:
              restore_tab_name(win_index)
              win_index = new_win_index
              set_tab_name(win_index, last_line)
finally:
    restore_tab_name(win_index)
