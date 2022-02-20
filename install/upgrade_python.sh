#!/bash/bin
set -x
REQ_LOCK=$(mktemp)
PY_VER=3.9.4
VNAME=nvim
pushd ~/dotfiles/
pyenv install "$PY_VER"
pyenv activate nvim
pip freeze | sed  -E 's/==.*//' > "$REQ_LOCK"
pyenv deactivate "$VNAME"
pyenv virtualenv-delete "$VNAME"
pyenv virtualenv "$PY_VER" "$VNAME"
pip install -r "$REQ_LOCK"
rm "$REQ_LOCK"
popd
