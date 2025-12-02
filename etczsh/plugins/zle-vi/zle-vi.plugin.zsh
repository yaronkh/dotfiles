zle_highlight=(region:bg=blue,fg=black)

# compy zle yank text to clipboard using OSC52
function vi-yank-osc52 {
    zle vi-yank  # Perform the default vi-yank action first
    local text_to_copy=$(echo -n "$CUTBUFFER" | base64)
    printf "\033]52;c;%s\a" "$text_to_copy"
}

zle -N vi-yank-osc52

bindkey -M vicmd 'y' vi-yank-osc52
## Optional: Show mode indicator in prompt
#function zle-keymap-select {
#  echo "run it"
#  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
#      echo "stop it"
#    echo -ne '\e[25m \e[1 q \e[25m'  # Block cursor
#  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ $1 = 'beam' ]]; then
#      echo "start it"
#    echo -ne '\e[5 q'  # Beam cursor
#  fi
#}
#zle -N zle-keymap-select

# Initialize on shell start
#echo -ne '\e[25m'
