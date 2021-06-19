PYVER=3.6.9
PYENV=~/.pyenv/bin/pyenv

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
    write_to_shrc 'export PYENV_ROOT="$HOME/.pyenv"'
    write_to_shrc 'export PATH="$PYENV_ROOT/bin:$PATH"'
    write_to_shrc 'if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init --path)";fi'
fi

export PATH=~/.pyenv/bin:$PATH

if ! ($PYENV versions | grep -qF $PYVER); then
    ensure_build_tools
    install_zlib
    if ! $PYENV install -k -s $PYVER; then echo "COULD NOT INSTALL PYTHON"; exit 255; fi
fi

if ! [ -d "$(pyenv root)/plugins/pyenv-virtualenv" ]; then
  git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv"
  write_to_shrc 'eval "$(pyenv virtualenv-init -)"'
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
