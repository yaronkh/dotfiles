install_tmux_compilation_prereq() {
  sudo yum install epel-release -y
  sudo yum update -y
  sudo yum install -y gcc
  sudo yum install -y bison
  sudo yum install -y libevent-devel
  sudo yum install -y autoconf
  sudo yum install -y automake
  sudo yum install -y ncurses-devel
  sudo yum install -y jq
  sudo yum install -y curl
  sudo yum install -y cargo
  sudo yum install -y npm
}

install_distro_ffi() {
    sudo yum -y install openssl11-devel
    sudo yum -y install libffi-devel
}


update_distro_db() {
    echo "refreshing yum db"
    sudo yum -y check-update > /dev/null
}

install_distro_build_tools() {
    sudo yum -y groupinstall "Development Tools"
    sudo yum -y install cargo
    sudo yum -y install ctags
}

install_distro_zlib() {
    sudo yum -y install zlib-devel openssl11-devel
}

verify_prereq() {
    if rpm -q openssl-devel > /dev/null 2>&1; then
        echo "Error: need to remove old openssl-devel. Please run \"rpm -e openssl-devel\""
        return 1
    fi
    return 0
}

install_distro_linters() {
    # install ag (silver-searcher) from source
    sudo yum install -y ripgrep fd-find
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
    target_nvim_ver="0.8.0"
    if ! which nvim
    then
        nvim_ver='0'
    else
        nvim_ver=$( nvim --version | head -1 | cut -d ' ' -f 2)
    fi
    if [ "$nvim_ver" != "$target_nvim_ver" ]
    then
        (
            cd ~
            sudo yum install -y  cmake
            sudo yum install -y libtool
	    echo "and the directory is $(pwd)"
            [ -d neovim ] && rm -rf neovim
            git clone https://github.com/neovim/neovim.git || exit 255
            cd neovim
	    pyenv local nvim
	    pyenv activate nvim
        sudo yum install cmake
            git checkout "v$target_nvim_ver"
            make CMAKE_BUILD_TYPE=RelWithDebInfo || exit 255
            sudo make install
        ) || exit 255
    fi
}
