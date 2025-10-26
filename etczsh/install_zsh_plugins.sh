#!/bin/bash

command=$1

plugins_root=$HOME/.oh-my-zsh/custom/plugins

plugins=(
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-completions.git"
    "zsh-users/zsh-syntax-highlighting.git"
    "yngc0der/zsh-ssh-config-suggestions"
    "z-shell/zsh-lsd.git"
    "fdellwing/zsh-bat.git"
    "zpm-zsh/colors"
    "unixorn/warhol.plugin.zsh.git"
    "unixorn/fzf-zsh-plugin.git"
    "MichaelAquilina/zsh-you-should-use"
    "bric3/nice-exit-code.git"
    "Aloxaf/fzf-tab"
)

oh_my_zsh_plg=(
    git
    git-commit
    git-extras
    jira
    procs
    rsync
    ssh
    sudo
    tmux
    pyenv
    aliases
    alias-finder
    zbell
    1password
    jsontools
    docker
    docker-compose
    debian
    )

for p in ${plugins[@]}; do
    p_name=$(basename "$p" | sed 's/\.git$//' | sed 's/\.zsh$//' | sed 's/\.plugin//')
    if [ "$command" = "print" ]; then
        echo "$p_name"
        continue
    fi
    if [ -d "$plugins_root/$p_name" ]; then
        if [ -d "$plugins_root/$p_name/.git" ]; then
            continue
        fi
        if [ -n "$plugins_root" ]; then
            rm -rf "${plugins_root:?}/$p_name"
        fi
    fi

    git clone "https://github.com/$p" "$plugins_root/$p_name"
done

ZSH_CUSTOM=${MY_VAR:-"$HOME/.oh-my-zsh/custom"}

pushd "$ZSH_CUSTOM/plugins" >/dev/null 2>&1

for d in ~/dotfiles/etczsh/plugins/*; do
    plugin_name=$(basename "$d")
    if [ "$command" = "print" ]; then
        echo "$plugin_name"
        continue
    fi

    if [ -d "$plugin_name" ] || [ -L "$plugin_name" ]; then
        continue
    fi
    ln -s "$HOME/dotfiles/etczsh/plugins/$plugin_name"
done

popd >/dev/null 2>&1

if [ "$command" = "print" ]; then
    for p in ${oh_my_zsh_plg[@]}; do
        echo "$p"
    done
else
    for f in aliases.zsh macos.zsh; do
        [ -L "$HOME/.oh-my-zsh/custom/$f" ] || ln -s "$HOME/dotfiles/etczsh/$f" "$HOME/.oh-my-zsh/custom/$f"
    done
fi
