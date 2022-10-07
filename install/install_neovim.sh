#!/bin/bash -x

source ~/dotfiles/install/utils/select_distro_funcs.sh

# run sudo to generate sudo credentials
sudo echo ""

install_distro_funcs

# make sure python is installed
source ~/dotfiles/install/utils/install_python.sh

pip install --upgrade setuptools
pip install jedi==0.17.2 mypy psutil pylint flake8 astroid pynvim neovim-remote || exit 255

if ! ctags --version > /dev/null 2>&1
then
    (
        set -e
        cd ~
        mkdir stuff
        cd stuff
        git clone https://github.com/rentalcustard/exuberant-ctags.git
        cd exuberant-ctags
        if ! ./configure; then echo "cannot build cscope"; exit 255; fi
        ./configure && make
        sudo make install
        cd
        rm -rf ~/stuff/exuberant-ctags
    ) || exit 255
fi

update_distro_db
install_distro_linters

#install neovim
(
    set -e
    install_distro_nvim
)

if ! mkdir -p ~/.config/nvim; then echo "cannot create nvim configuration directory"; exit 255; fi
if ! cp -R -u -p nvim ~/.config/; then echo "Cannot copy nvim configuration files"; exit 255; fi

nvim +PlugInstall2 +qa

write_to_shrc 'source ~/dotfiles/local/nvim.bash'

echo
echo "PLEASE RUN source ~/.bashrc, in order for changes to take effect"

