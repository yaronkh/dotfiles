#!/bin/zsh
#
fpath=($HOME/dotfiles/etczsh/plugins/deploy_editor_config $fpath)

alias dep='deploy_editor_config'

deploy_editor_config() {
        ~/dotfiles/proj_deploy/create_editor_config.bash $@ | grcat ~/dotfiles/grc/conf.simple
}


