export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init --path 2>/dev/null)"; fi
eval "$(pyenv virtualenv-init -)"

nvim() (
  pyenv activate nvim > /dev/null 2>&1
  TOP_DIR=$(git rev-parse --show-toplevel 2> /dev/null)
  if [ -n "$TOP_DIR" ] && [ -d "$TOP_DIR" ] && [ -f "$TOP_DIR/.py_include" ]; then
    while IFS="" read -r p
    do
      export PYTHONPATH="$TOP_DIR/$p:$PYTHONPATH"
    done < "$TOP_DIR/.py_include"
  fi
  exec $(which nvim) "$@"
)
