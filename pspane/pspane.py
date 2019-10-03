#!/usr/bin/env python

import sys
import os
import subprocess
import time
import psutil
import curses

try:
    subprocess.check_call(['tmux','selectp','-Z','-t',sys.argv[2]])
    pid = int(sys.argv[1])
    if not psutil.pid_exists(pid):
        raise RuntimeError("process not found")
    curses.setupterm()
    place_begin = curses.tparm(curses.tigetstr("cup"), 0, 0)
    invi =  curses.tparm(curses.tigetstr("civis"))
    printed_tree = ""
    subprocess.check_output(['stty', '-echo'])
    while psutil.pid_exists(pid):
      curr_tree = subprocess.check_output(['pstree','-G','-l', str(pid)])[:-1]
      if curr_tree != printed_tree:
          subprocess.check_call(['tput', 'clear'])
          printed_tree = curr_tree
          print (place_begin + printed_tree + invi)
      time.sleep(2)
finally:
    subprocess.check_output(['stty', 'echo'])
    print(curses.tparm(curses.tigetstr("cvvis")))
    pass
