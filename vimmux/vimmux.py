#!/usr/bin/env python

import sys
import os
import subprocess
import time
import psutil
import re
import tempfile


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
        self.id, self.stat, self.edit_sign, self.fn, self.line = desc_match.groups()
        self.line = int(self.line)
        self.id = int(self.id)
        self.editor = editor

    def show(self):
        #check if the current buffer is in edit mode
        if self.editor.is_buff_in_edit_mode() and self.fn != self.editor.get_active_buf_name():
            subprocess.check_call(['vim', '--servername', self.editor.name, '--remote-expr', 'execute("tabnew {0}")'.format(self.fn)])
        else:
            subprocess.check_call(['vim', '--servername', self.editor.name, '--remote-expr', 'execute("buffer {0}")'.format(self.id)])

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
        for l in self.get_file_list():
            vfile = VimFile(l, self)
            if vfile.fn == '[No Name]':
                continue
            self.files[vfile.fn] = vfile

    def is_buff_in_edit_mode(self):
        for desc in self.get_file_list():
            v = VimFile(desc, self)
            if v.stat == '%a':
               return v.edit_sign == "+"

    def get_active_buf_name(self):
        for desc in self.get_file_list():
            v = VimFile(desc, self)
            if v.stat == '%a':
               return v.fn

    def get_file_list(self):
        files_list = subprocess.check_output(['vim', '--servername', self.name, '--remote-expr', 'execute("ls")']).split('\n')
        for l in files_list:
            if len(l):
                yield l

    def cwd(self):
        self.pwd = subprocess.check_output(['vim', '--servername', self.name, '--remote-expr', 'execute("pwd")'])
        self.pwd = self.pwd.split('\n')[-2]
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
        self.tmux_pane = TmuxCom.get_pane(self.pane_pid)

    def append(self, opts):
        for fn, buf in self.files.items():
            opts.append("{0}: {1}".format(self.name, buf.fn))

    def select(self, name):  
        if self.tmux_pane == None:
            return
        self.tmux_pane.focus()
        if name in self.files:
            self.files[name].show()

    def stash(self, file_name, forpid):
        if not file_name in self.files:
            return None
        file_obj = self.files[file_name]
        file_obj.show()
        ffname = os.path.basename(file_name)
        temp_fn = os.path.join(tempfile.gettempdir(), '{1}-{2}.{0}'.format(ffname, self.pid, forpid ))
        subprocess.check_call(['vim', '--servername', self.name, '--remote-expr', 'execute("write {0}")'.format(temp_fn)])
        subprocess.check_call(['vim', '--servername', self.name, '--remote-send', '<C-\><C-N>:bd!<CR>'])
        file_obj.show()
        subprocess.check_call(['vim', '--servername', self.name, '--remote-send', '<C-\><C-N>:bd!<CR>'])
        return temp_fn

    def close_file(self, file_name):
        file_obj = self.files[file_name]
        file_obj.show()
        subprocess.check_call(['vim', '--servername', self.name, '--remote-send', '<C-\><C-N>:bd!<CR>'])

    def open_file(self, file_name):
        if file_name != None and len(file_name):
            if self.is_buff_in_edit_mode():
                subprocess.check_call(['vim', '--servername', self.name, '--remote-expr', 'execute("tabnew {0}")'.format(file_name)])
            else:
                subprocess.check_call(['vim', '--servername', self.name, '--remote-expr', 'execute("edit {0}")'.format(file_name)])

    def move_file(self, editor, file_name):
        if editor == self or not len(file_name):
            return
        orig_file_name = file_name
        file_name = os.path.expanduser(file_name)
        if os.path.isabs(file_name):
            target_path = file_name
        else:
            target_path = os.path.relpath(os.path.join(editor.pwd, file_name), self.pwd)
            if len(target_path) >= 2 and target_path[:2] == "..":
                target_path = os.path.abspath(os.path.join(self.pwd, target_path))
        modified = editor.is_buff_in_edit_mode()
        if not modified:
            editor.close_file(orig_file_name)
            self.open_file(target_path)
            return

        temp_fn = editor.stash(file_name, self.pid)
        if temp_fn != None and len(temp_fn):
            self.open_file(temp_fn)
            subprocess.check_call(['vim', '--servername', self.name, '--remote-expr', 'execute("file {0}")'.format(target_path)])
            if modified:
                subprocess.check_call(['vim', '--servername', self.name, '--remote-expr', 'execute("set modified")'])
            os.unlink(temp_fn)

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

    def select_file(self):
        selection = FzFSelect(self.get_selection_list())
        if len(selection):
            self.select(selection)

    def move_file(self):
        selection = FzFSelect(self.get_selection_list())
        target_pane = sys.argv[2]
        if len(selection):
            self.move(target_pane, selection)

    def select(self, s):
        m = VimComm.buf_repr_re.match(s)
        if m != None:
            server, fl = m.groups()
            if server in  self.vims:
                self.vims[server].select(fl)

    def move(self, target_pane, s):
        m = VimComm.buf_repr_re.match(s)
        if m != None:
            source, fl = m.groups()
            if not source in self.vims:
                return
        else:
            return
        target = ''
        target_vim = None
        for server, vim in self.vims.items():
            if target_pane == vim.tmux_pane.id:
                target = server
                target_vim = vim
                break
        if target_vim == None:
            return
        target_vim.move_file(self.vims[source], fl)

def FzFSelect(opts):
    p = subprocess.Popen(['fzf', '--layout=reverse-list'] , stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    res = p.communicate(input='\n'.join(opts))[0]
    return res[:-1]



time.sleep(0.05)
TmuxCom.Init()
v = VimComm()
v.refresh()
if len(sys.argv) < 2 or sys.argv[1] == "select":
    v.select_file();
    exit(0)
if sys.argv[1] == "move":
    v.move_file()
    exit(0)
