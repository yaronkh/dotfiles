#!/bin/bash -x

required_ver=$1

eval "$(~/.pyenv/bin/pyenv init -)"

test -d "pyenv/versions/$required_ver" || ( eval "$(~/.pyenv/bin/pyenv init -)" && ~/.pyenv/bin/pyenv install "$required_ver")

pyver=$(pyenv versions | grep -v '\-\->' | grep nvim | cut -d / -f 1)
if [ "$pyver" != "$required_ver" ]; then
    yes | pyenv virtualenv-delete nvim
    pyenv virtualenv "$required_ver" nvim
    pyenv local nvim
    pyenv activate nvim
    pip install -U -r requirements.txt
fi
