export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init --path 2>/dev/null)"; fi
eval "$(pyenv virtualenv-init -)"

nvim() (
  pyenv activate nvim > /dev/null 2>&1
  exec command nvim "$@"
)
