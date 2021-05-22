update_distro_db() {
    sudo apt-get update
}

install_distro_build_tools() {
    sudo apt-get install -y build-essential || exit 255
}

install_distro_zlib() {
    sudo apt-get install -y zlib1g zlib1g-dev libssh-dev || exit 255
}

install_distro_linters() {
    sudo apt-get install -y clang
    sudo apt-get install -y cscope aptitude global silversearcher-ag || exit 255
}

install_distro_nvim() {
    if grep -q 'VERSION="14.04.5' /etc/os-release; then
        sudo add-apt-repository ppa:neovim-ppa/unstable
    else
        sudo add-apt-repository -y ppa:neovim-ppa/stable
    fi
    sudo apt-get update
    sudo apt-get install -y neovim
}

