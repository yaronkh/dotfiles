set -e

PYVER=3.11.0
PYENV=~/.pyenv/bin/pyenv

if ! verify_prereq; then
    ee=$?
    echo "canno install python, please fix the above error, and re-execute the scripts"
    exit $ee
fi

ensure_build_tools() {
    if ! which cc > /dev/null
    then
        install_distro_build_tools
    fi
}

install_zlib() {
   install_distro_zlib
}

write_to_shrc() {
    for f in ~/.bashrc ~/.zshrc $BASHRC
    do
        if [ -f "$f" ]; then
            echo "write to $f"
            if ! grep -q "$1" "$f"; then
                echo "$1" >> "$f"
            fi
        fi
    done
    eval "$1"
}

if [ ! -d ~/.pyenv ]; then
    if ! git clone https://github.com/pyenv/pyenv.git ~/.pyenv; then echo "COULD NOT DOWNLOAD penv"; exit 255; fi
fi

cd ~

export PATH=~/.pyenv/bin:$PATH

if ! ($PYENV versions | grep -qF $PYVER); then
    ensure_build_tools
    install_distro_ffi
    install_zlib
    export PATH=~/.pyenv/versions/3.11.0/bin:$PATH
    if ! CONFIGURE_OPTS='--with-system-ffi' $PYENV install -k -s $PYVER; then echo "COULD NOT INSTALL PYTHON"; exit 255; fi
fi

if ! [ -d "$(pyenv root)/plugins/pyenv-virtualenv" ]; then
  git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv"
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
cd ~/dotfiles; pyenv local $PYVER || exit 255
cd ~/dotfiles; pyenv virtualenv "$PYVER" nvim
cd ~/dotfiles; pip install --upgrade pip || exit 255
pyenv activate nvim || exit 255;
python -m pip install --upgrade pip || exit 255
