# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ykahanovitch/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/ykahanovitch/.fzf/bin"
fi

# Auto-completion
# ---------------
source "/home/ykahanovitch/.fzf/shell/completion.bash"

# Key bindings
# ------------
source "/home/ykahanovitch/.fzf/shell/key-bindings.bash"
