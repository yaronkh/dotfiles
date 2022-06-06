install_tmux_compilation_prereq() {
  sudo yum install -y gcc
  sudo yum install -y bison
  sudo yum install -y libevent-devel
  sudo yum install -y autoconf
  sudo yum install -y automake
  sudo yum install -y ncurses-devel
}


update_distro_db() {
    echo "refreshing yum db"
    sudo yum -y check-update > /dev/null
}

install_distro_build_tools() {
    sudo yum -y group install "Development Tools"
}

install_distro_zlib() {
    sudo yum -y install zlib-devel openssl-devel
}

install_distro_linters() {
    sudo yum -y install clang cscope
    # install ag (silver-searcher) from source
    if ! which ag > /dev/null
    then
    (
        cd ~
        sudo yum install -y pcre-devel
        sudo yum install -y xz-devel
        sudo yum install -y automake
        [ -d the_silver_searcher ] && sudo rm -rf the_silver_searcher
        git clone https://github.com/ggreer/the_silver_searcher.git
        cd the_silver_searcher
        ./build.sh || exit 255
        sudo make install || exit 255
    ) || exit 255
    fi
}

install_distro_nvim() {
    target_nvim_ver="0.6.1"
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
            sudo yum install -y  cmake
            sudo yum install -y libtool
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
