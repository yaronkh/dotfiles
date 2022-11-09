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
    target_nvim_ver="0.7.2"
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

install_distro_xclip() (
    set -e
    sudo yum install -y libXmu-devel xauth
    git clone https://github.com/astrand/xclip.git
    pushd xclip
    ./bootstrap
    ./configure
    make
    sudo make install
    popd
)

