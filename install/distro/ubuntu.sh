install_tmux_compilation_prereq() {
  sudo apt-get install -y pkg-config
  sudo apt-get install -y build-essential
  sudo apt-get install -y gcc
  sudo apt-get install -y bison
  sudo apt-get install -y libevent-dev
  sudo apt-get install -y autotools-dev
  sudo apt-get install -y automake
  sudo apt-get install -y libncurses5-dev libncursesw5-dev
  sudo apt-get install -y jq
  sudo apt-get install -y curl
  install_distro_xclip
}


update_distro_db() {
    sudo apt-get update
}

install_distro_ffi() {
    sudo apt-get install -y libffi-dev || exit 255
}

verify_prereq() {
    return 0
}

install_distro_build_tools() {
    sudo apt-get install -y build-essential || exit 255
}

install_distro_zlib() {
    sudo apt-get install -y zlib1g zlib1g-dev libssh-dev || exit 255
}

install_distro_linters() {
    sudo apt-get install -y clang clangd
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

install_distro_xclip() {
    sudo apt-get install -y xclip xauth
}
