#!/usr/bin/env python

import sys
import os
import subprocess
import time
import psutil
import re

class TmuxPane(object):
    def __init__(self, pane_pid, pane_id, window_index):
        self.pid, self.id, self.window = pane_pid, pane_id, window_index
        self.pid = int(self.pid)


class TmuxCom(object):
    panes = {}
    server_pid = -1

    @staticmethod
    def Init():
        TmuxCom.panes = {}
        TmuxCom.server_pid = -1
        pane_list = subprocess.check_output(['tmux','list-panes','-a','-F',"#{pane_pid} #{pane_id} #{window_index} #{pid}"])[:-1].split('\n')
        for p in pane_list:
            pane_pid, pane_id, window_index, TmuxCom.server_pid = p.split()
            TmuxCom.server_pid = int(TmuxCom.server_pid)
            t = TmuxPane(pane_pid, pane_id, window_index)
            TmuxCom.panes[t.pid] = t

class VimFile(object):
    desc_re = re.compile("^ *([0-9]+) +([^ ]*) +\"(.*)\" +line ([0-9]+)$")
    def __init__(self, desc):

        desc_match = VimFile.desc_re.match(desc)
        if not desc_match:
            raise RuntimeError("line {0} did not match".format(desc))
        self.id, self.stat, self.fn, self.line = desc_match.groups()
        self.line = int(self.line)
        self.id = int(self.id)

class VimInstance(object):
    def __init__(self, name):
        self.name = name
        self.is_tmux_vim = False
        self.cwd()
        self.files = {}
        self.pid = subprocess.check_output(['vim', '--servername', name, '--remote-expr', 'execute("echo getpid()")'])
        self.pid = int(self.pid.split('\n')[-2])
        self.pane_pid = -1
        self.check_tmux_vim()
        files_list = subprocess.check_output(['vim', '--servername', name, '--remote-expr', 'execute("ls")']).split('\n')
        files_list = [ l for l in files_list if len(l) ]
        for l in files_list:
            vfile = VimFile(l)
            if vfile.fn == '[No Name]':
                continue
            self.files[self.pwd + vfile.fn] = vfile

    def cwd(self):
        self.pwd = subprocess.check_output(['vim', '--servername', self.name, '--remote-expr', 'execute("pwd")'])
        self.pwd = self.pwd.split('\n')[-1]
        return self.pwd

    def check_tmux_vim(self):
        p = self.pid
        try:
            pr = psutil.Process(p)
        except:
            return
        parent = pr.ppid()
        self.is_tmux_vim = False
        while parent != 1:
            if parent == TmuxCom.server_pid:
                self.is_tmux_vim = True
                self.pane_pid = p
                break
            p = parent
            parent = psutil.Process(p).ppid()
        print "found pane_pid {0}".format(self.pane_pid)

class VimComm(object):
    def __init__(self):
        self.vims = {}

    def refresh(self):
        vim_servers = subprocess.check_output(['vim', '--serverlist']).split('\n')
        for server in vim_servers:
            if len(server) == 0:
                continue
            v = VimInstance(server)
            if v.is_tmux_vim:
                self.vims[server] = v


TmuxCom.Init()

v = VimComm()
v.refresh()
