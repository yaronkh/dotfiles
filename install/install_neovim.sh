#!/usr/bin/env bash

if ! command -v nvim > /dev/null; then
        sudo add-apt-repository ppa:neovim-ppa/stable || die "cannot add neovim repo"
        sudo apt-get update || die "cannot update repositories database"
        sudo apt-get install -y neovim || die "could not install neovim"
fi

[ -d ~/.config/nvim ] || mkdir -p "~/.config/nvim" || die "cannot create .config/nvim directory"
if [ -f ~/.config/nvim/init.vim ]; then
        if ! grep -q dotfiles/nvim/src/init.vim ~/.config/nvim/init.vim; then
                cat ~/dotfiles/nvim/init.vim >> ~/.config/nvim/init.vim || die "cannot prepare .config/nvim/init.vim"
        fi
else
        cp ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim || die "cannot deploy nvim init.vim"
fi

[ -d ~/.config/nvim/after/plugin] && rm -rf ~/.config//nvim/after/plugin
cp -r ~/dotfiles/nvim/after ~/.config/nvim/ || die "cannot deploy nvim after files"
! [ -d ~/.config/nvim/autoload ] && mkdir ~/.config/nvim/autoload
if ! [ -f ~/.config/nvim/autoload/plug.vim]; then
        cp ~/dotfiles/nvim/autoload/plug.vim ~/.config/nvim/autoload/ || die "cannot deploy plug.vim"
fi

sudo apt install silversearcher-ag exuberant-ctags cscope global codesearch -y || die "cannot install vim depended packages"
nvim +PlugInstall +qall || die "cannot install vim plugins"
