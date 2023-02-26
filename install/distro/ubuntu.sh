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
#    sudo apt-get update && sudo apt-get install -y yarn
#    curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
    sudo apt-get install -y aptitude global silversearcher-ag || exit 255
}

install_distro_nvim() {
    sudo apt-get install gettext
    target_nvim_ver="v0.8.0"
    if ! which nvim
    then
        nvim_ver='0'
    else
        nvim_ver=$( nvim --version | head -1 | cut -d ' ' -f 2)
    fi
    if [ "$nvim_ver" != "$target_nvim_ver" ]
    then
        (
            set -e
            cd ~
            sudo apt-get install -y libtool libtool-bin zip gettext
            git clone https://github.com/neovim/neovim.git || exit 255
            cd neovim
	    pyenv local nvim
	    pyenv activate nvim
	    pip install cmake
            git checkout "v$target_nvim_ver"
            make CMAKE_BUILD_TYPE=RelWithDebInfo || exit 255
            sudo make install
        ) || exit 255
    fi
}

install_distro_xclip() {
    sudo apt-get install -y xclip xauth
}
