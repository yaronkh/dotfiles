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
    sudo apt-get install -y clang cscope aptitude global silversearcher-ag || exit 255
}

install_distro_nvim() {
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install -y neovim
}

