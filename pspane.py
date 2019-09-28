#!/usr/bin/env python

import sys
import os
import subprocess
import time
import psutil
import curses

try:
    subprocess.check_output(['stty', '-echo'])
    curses.setupterm()
    place_begin = curses.tparm(curses.tigetstr("cup"), 0, 0)
    invi =  curses.tparm(curses.tigetstr("civis"))
    printed_tree = ""
    pid = int(sys.argv[1])
    while psutil.pid_exists(pid):
      curr_tree = subprocess.check_output(['pstree','-G',str(pid)])[:-1]
      if curr_tree != printed_tree:
          print"\033c", 
          printed_tree = curr_tree
          print place_begin + printed_tree + invi
      time.sleep(2)
finally:
    pass
