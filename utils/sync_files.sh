filter_procs() {
    pattern=$1
    shift

    # The rest of the arguments are the filter parameters for ps
    filter_params="$1"

    # Find the process IDs using pgrep
    pids=$(pgrep -f "$pattern" 2>/dev/null)

    # Check if any PIDs were found
    if [ -z "$pids" ]; then
        return 0
    fi

    # Use ps to get the full command and filter based on the provided parameters
    for pid in $pids; do
        cmd=$(ps -p "$pid" -o args=)
        if echo "$cmd" | grep -q "$filter_params" ; then
            echo "$pid"
            return 0
        fi
    done
    return 255
}

if ! [ -d ".git" ]; then
    echo "This script must be run from the root of the git repository"
    return 255
fi

pid=$(filter_procs lsyncd "$(pwd)")
if [ "$1" = "start" ]; then
    if [ -n "$pid" ]; then
        echo "Lsyncd is already running"
        return 255
    else
        lsyncd -rsyncssh "$(pwd)" nvme31 "$(pwd)"
        return $?
    fi
elif [ "$1" = "stop" ]; then
    if [ -n "$pid" ]; then
        echo "Stopping lsyncd $pid"
        kill -9 "$pid"
        return $?
    else
        echo "Lsyncd is not running"
        return 255
    fi
fi

