#!/bin/bash
set -x
REQ_LOCK=$(mktemp)
PY_VER=3.9.4
VNAME=nvim
pushd ~/dotfiles/
if ! (pyenv versions | grep -q "$PY_VER"); then
  pyenv install "$PY_VER"
fi

if ! (pyenv version | grep -q -E "^$VNAME"); then
  pyenv activate "$VNAME"
fi

pip freeze | sed  -E 's/==.*//' > "$REQ_LOCK"
pushd ~

if pyenv version | grep -q -E "^$VNAME"; then
  pyenv deactivate "$VNAME"
fi


echo Y | pyenv virtualenv-delete "$VNAME"
pyenv virtualenv "$PY_VER" "$VNAME"
pip install -r "$REQ_LOCK"
popd
popd
