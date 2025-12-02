
YK_SUDO_PLUGIN_DIR=$(dirname $0)

function sudo()
{
    export  export SUDO_ASKPASS=${YK_SUDO_PLUGIN_DIR}/yk_askpass.zsh
    command sudo -A "$@"
}
