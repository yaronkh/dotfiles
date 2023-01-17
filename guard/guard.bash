#!/bin/bash

printf '%s\n' '
        .-"""-.
       / .===. \
       \/ 6 6 \/
       ( \___/ )
  _ooo__\_____/______
 /                   \
| I will alarm you   |
 \_______________ooo_/
        |  |  |
        |_ | _|
        |  |  |
        |__|__|
        /- | -\
       (__/ \__)
'
cmd_info=$(ps -f --ppid $2 -eo comm,pid | tail -1)
command=$(echo "$cmd_info" | tr -s ' ' | cut -d ' ' -f 1)
my_pid=$(echo "$cmd_info"  | tr -s ' ' | cut -d ' ' -f 2)
# my_pwd=$(readlink -e "/proc/$my_pid/cwd")
my_args=$(tr '\0' ' ' < "/proc/$my_pid/cmdline")
elapsed="0"
ela=$(ps -o etimes -p $$ 2>/dev/null | tail -n +2 | xargs)
pane_id=$1
[ -n "$ela" ] && elapsed=$ela
if [ -n "$my_args" ]; then
    if [[ "$my_args" = "$command"* ]]; then
        command="$my_args"
    else
        command="$command $my_args"
    fi
fi

echo -e "Watching $command\npid: $my_pid"

function notify() {
  tput bel
  slack_url=$(tmux show -gv "@slack_url" 2> /dev/null)
  if [ -n "$slack_url" ]; then
        fn=$(mktemp)
        tmux capture-pane -S -5 -t "$pane_id"; tmux save-buffer "$fn"; tmux delete-buffer
        sed -i '/^ *$/d' "$fn"
        echo ":" >> "$fn"
        output=$(tail -6 "$fn")
        #rm "$fn"
      	# Build the JSON request and POST it to the webhook
        # --arg hostname "$(uname -n)" \
		json=$(jq -n \
			--arg command "$command" \
			--arg hostname "$output" \
			--arg output "$output" \
			--arg pwd "" \
            --arg elapsed "$elapsed" \
            --arg result 0 \
			'{command: $command, hostname: $hostname, output: $output, pwd: $pwd, elapsed: $elapsed, result: $result}'
		)
		curl -X POST "$slack_url" -H "Content-Type:application/json" -s --data "$json" -o /tmp/yaron
  fi
  echo "ring ring"
  sleep 1
  exit 0
}

if [[ "$command" == ssh* ]]; then
    echo -e "\e[1;31mATTEMPT TO WATCH SSH\e[0m"
fi

while true; do
    lines=$(ps -f --ppid $2 | wc -l)
    ela=$(ps -o etimes -p "$my_pid" 2>/dev/null | tail -n +2 | xargs)
    [ -n "$ela" ] && elapsed=$ela
    if [ "$lines" -le 1 ]; then
        notify
    fi
    echo -ne "$elapsed seconds\033[0K\r"
    sleep 1
done
