
install_distro_funcs()
{
    if grep -q "ID=ubuntu" /etc/os-release
    then
        source ~/dotfiles/install/distro/ubuntu.sh
        return
    elif grep -q rhel /etc/os-release
    then
        source ~/dotfiles/install/distro/rhel.sh
        return
    fi
    echo "DISTRO NOT SUPPORTED"
    exit 255
}

install_distro_funcs
