alias lg='git lg -10'
alias lgg='git lg'
alias n='nvim'

alias v='nvim'
alias t=take

alias lsm='lsmod | grep nvmeib'
alias ls=lsd

alias make='/home/ykahanovitch/dotfiles/build/bin/make'
alias sync='lsyncd ~/dotfiles/nvidia/lsync_conf.lua'

alias rmext='delete_untracked_files_with_extension'

alias p='pwd'
alias m='make -j'

alias pver='pyenv versions | bat -pl ls'

alias h='hostname'

alias gfh='git_func_hist'

alias lzg='lazygit'

alias sl='grcat conf.log'

alias c='nvm >/dev/null && command codex'

alias sshi='ssh -o identitiesOnly=yes root@'

alias scpi='scp -o identitiesOnly=yes'

alias gb_new="git for-each-ref --sort=-committerdate --count=20 --format='%(committerdate:short) %(refname:short)' refs/heads/ | bat -pl syslog"
