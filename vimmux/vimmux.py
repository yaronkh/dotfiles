#!/usr/bin/env python

import sys
import os
import subprocess
import time
import psutil
import re

class TmuxPane(object):
    def __init__(self, session_id, pane_pid, pane_id, window_index):
        self.pid, self.id, self.window = pane_pid, pane_id, window_index
        self.pid = int(self.pid)
        self.session_id = session_id

    def focus(self):
        #current_session = subprocess.check_output(['tmux', 'display-message', '-p', '$#S']).split('\n')[0]
        subprocess.check_call(['tmux', 'selectw', '-t', self.window])
        subprocess.check_call(['tmux', 'selectp', '-Z', '-t', self.id])

class TmuxCom(object):
    panes = {}
    server_pid = -1
    current_session = ""

    @staticmethod
    def Init():
        TmuxCom.panes = {}
        TmuxCom.server_pid = subprocess.check_output(['tmux', 'display-message', '-p', '#{pid}'])
        TmuxCom.server_pid = int(TmuxCom.server_pid, 10)
        TmuxCom.current_session = subprocess.check_output(['tmux', 'display-message', '-p', '$#S']).split('\n')[0]
        pane_list = subprocess.check_output(['tmux','list-panes','-a','-F',"#{session_id} #{pane_pid} #{pane_id} #{window_id}"])[:-1].split('\n')
        for p in pane_list:
            session_id, pane_pid, pane_id, window_index = p.split()
            t = TmuxPane(session_id, pane_pid, pane_id, window_index)
            TmuxCom.panes[t.pid] = t

    @staticmethod
    def get_pane(pane_pid):
        if pane_pid in TmuxCom.panes:
            return TmuxCom.panes[pane_pid]
        else:
            return None
        

class VimFile(object):
    desc_re = re.compile("^ *([0-9]+) +([^ ]*) +([^ ]*) *\"(.*)\" +line ([0-9]+)$")
    def __init__(self, desc, editor):

        desc_match = VimFile.desc_re.match(desc)
        if not desc_match:
            raise RuntimeError("line {0} did not match".format(desc))
        self.id, self.stat, _, self.fn, self.line = desc_match.groups()
        self.line = int(self.line)
        self.id = int(self.id)
        self.editor = editor

    def show(self):
        subprocess.check_call(['vim', '--servername', self.editor.name, '--remote-expr', 'execute("buffer! {0}")'.format(self.id)])

class VimInstance(object):
    def __init__(self, name):
        self.name = name
        self.is_tmux_vim = False
        self.cwd()
        self.files = {}
        self.pid = subprocess.check_output(['vim', '--servername', name, '--remote-expr', 'execute("echo getpid()")'])
        self.pid = int(self.pid.split('\n')[-2])
        self.tmux_pane = None
        self.pane_pid = -1
        self.check_tmux_vim()
        files_list = subprocess.check_output(['vim', '--servername', name, '--remote-expr', 'execute("ls")']).split('\n')
        files_list = [ l for l in files_list if len(l) ]
        for l in files_list:
            vfile = VimFile(l, self)
            if vfile.fn == '[No Name]':
                continue
            self.files[vfile.fn] = vfile

    def cwd(self):
        self.pwd = subprocess.check_output(['vim', '--servername', self.name, '--remote-expr', 'execute("pwd")'])
        self.pwd = self.pwd.split('\n')[-1]
        return self.pwd

    def check_tmux_vim(self):
        p = self.pid
        try:
            pr = psutil.Process(p)
        except:
            print ("not a Process")
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
        self.tmux_pane = TmuxCom.get_pane(self.pane_pid)
        #print "found pane_pid {0}".format(self.pane_pid)

    def append(self, opts):
        for fn, buf in self.files.items():
            opts.append("{0}: {1}".format(self.name, buf.fn))

    def select(self, name):  
        if self.tmux_pane == None:
            return
        self.tmux_pane.focus()
        if name in self.files:
            self.files[name].show()


class VimComm(object):
    buf_repr_re = re.compile("^(.*): *(.*)$")
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

    def get_selection_list(self):
        res = []
        for vim_name, vim in self.vims.items():
            vim.append(res)
        return res

    def select(self, s):
        m = VimComm.buf_repr_re.match(s)
        if m != None:
            server, fl = m.groups()
            if server in  self.vims:
                self.vims[server].select(fl)

def FzFSelect(opts):
    p = subprocess.Popen(['fzf', '--layout=reverse-list'] , stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    res = p.communicate(input='\n'.join(opts))[0]
    return res[:-1]

time.sleep(0.05)
TmuxCom.Init()
v = VimComm()
v.refresh()
selection = FzFSelect(v.get_selection_list())
if len(selection):
    v.select(selection)
