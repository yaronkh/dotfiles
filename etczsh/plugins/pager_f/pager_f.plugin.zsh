#!/bin/zsh
#
fpath=($HOME/dotfiles/etczsh/plugins/pager_f $fpath)

alias pgy='pager_f'
alias ./pager.py='pager_f'

function pager_f() {
    command ./pager.py --nogreet --print-date $@ | bat --color=always -pl syslog
}

