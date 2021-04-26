#!/bin/bash

PYVER=3.6.9
VENV_ROOT=~/.config/dotfiles/venv
PYENV=~/.pyenv/bin/pyenv

BASHRC=$(mktemp)
touch $BASHRC

function install_distro_funcs()
{
    if grep -q "ID=ubuntu" /etc/os-release
    then
        source ~/dotfiles/install/distro/ubuntu.sh
        return
    elif grep -q rhel /etc/os-release
    then
        source ~/dotfiles/install/distro/rhel.sh
        return
    fi
    echo "DISTRO NOT SUPPORTED"
    exit 255
}

function atexit_handler() {
    rm $BASHRC
}

function write_to_shrc() {
    for f in ~/.bashrc ~/.zshrc $BASHRC
    do
        if [ -f "$f" ]; then
            echo "write to $f"
            if ! grep -q "$1" $f; then
                echo $1 >> "$f"
            fi
        fi
    done
    eval $1
}

# run sudo to generate sudo credentials
sudo echo ""

function ensure_build_tools() {
    if ! which cc > /dev/null
    then
        install_distro_build_tools
    fi
}

function install_zlib() {
   install_distro_zlib
}

install_distro_funcs

if [ ! -d ~/.pyenv ]; then
    if ! git clone https://github.com/pyenv/pyenv.git ~/.pyenv; then echo "COULD NOT DOWNLOAD penv"; exit 255; fi
    write_to_shrc 'export PYENV_ROOT="$HOME/.pyenv"'
    write_to_shrc 'export PATH="$PYENV_ROOT/bin:$PATH"'
    write_to_shrc 'if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init -)";fi'
fi

export PATH=~/.pyenv/bin:$PATH

if ! ($PYENV versions | grep -qF $PYVER); then
    ensure_build_tools
    install_zlib
    if ! $PYENV install -k -s $PYVER; then echo "COULD NOT INSTALL PYTHON"; exit 255; fi
fi

mkdir -p $VENV_ROOT || exit 255

source $BASHRC

(cd ~/dotfiles; $PYENV local $PYVER) || exit 255
(cd ~/dotfiles; pip install --upgrade pip; pip install virtualenv) || exit 255
(cd ~/dotfiles; python -m venv $VENV_ROOT) || exit 255
(cd ~/dotfiles; source $VENV_ROOT/bin/activate; pip install jedi psutil pylint flake8 astroid pynvim neovim-remote) || exit 255
(source $VENV_ROOT/bin/activate; pip install --upgrade pip)

if ! which ctags > /dev/null
then
    (
        set -e
        cd ~
        mkdir stuff
        cd stuff
        git clone https://github.com/rentalcustard/exuberant-ctags.git
        cd exuberant-ctags
        if ! ./configure; then echo "cannot build cscope"; exit 255; fi
        ./configure && make
        sudo make install
        cd
        rm -rf ~/stuff/exuberant-ctags
    ) || exit 255
fi

update_distro_db
install_distro_linters

#install neovim
(
    set -e
    install_distro_nvim
)

if ! mkdir -p ~/.config/nvim; then echo "cannot create nvim configuration directory"; exit 255; fi
if ! cp -R -u -p nvim ~/.config/; then echo "Cannot copy nvim configuration files"; exit 255; fi
if [ -z "$NVIM_BASHRC" ] ; then
    write_to_shrc "source ~/dotfiles/local/nvim_bashrc"
fi
source $BASHRC
nvim +PlugInstall +PlugUpdate +qa

echo
echo "PLEASE RUN source ~/.bashrc, in order for changes to take effect"

