#!/bin/bash -x

source ~/dotfiles/install/utils/select_distro_funcs.sh

if ! node -v; then
  echo "nodejs is not installed. please install latest nodejs"
  echo "to instsall:"
  echo "for rhel:"
  echo "========="
  echo "curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -"
  echo "sudo yum install nodejs"

  echo "for ubuntu:"
  echo "========="
  echo "curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -"
  echo "sudo apt install nodejs"
  exit 255
fi

install_dev_tools

# run sudo to generate sudo credentials
sudo echo ""

install_distro_funcs

# make sure python is installed
source ~/dotfiles/install/utils/install_python.sh

pip install --upgrade setuptools
pip install jedi==0.17.2 mypy psutil pylint flake8 astroid pynvim neovim-remote || exit 255

# if ! ctags --version > /dev/null 2>&1
# then
#     (
#         set -e
#         cd ~
#         mkdir stuff
#         cd stuff
#         git clone https://github.com/rentalcustard/exuberant-ctags.git
#         cd exuberant-ctags
#         if ! ./configure; then echo "cannot build cscope"; exit 255; fi
#         ./configure && make
#         sudo make install
#         cd
#         rm -rf ~/stuff/exuberant-ctags
#     ) || exit 255
# fi

if ! which xclip
then
    echo "xlip is not installed, installing it"
    install_distro_xclip
fi

update_distro_db
install_distro_linters

#install neovim
(
    echo installing neovim
    install_distro_nvim
)

if ! mkdir -p ~/.config/nvim; then echo "cannot create nvim configuration directory"; exit 255; fi
if ! cp -R -u -p nvim ~/.config/; then echo "Cannot copy nvim configuration files"; exit 255; fi

nvim +PlugInstall2 +UpdateRemotePlugins +qa

write_to_shrc 'source ~/dotfiles/local/nvim.bash'

if ! [ -e ~/.config/nvim/coc-settings.json ]; then
    cp ~/dotfiles/etc_clang/coc-settings.json ~/.config/nvim/coc-settings.json
fi

echo
echo "PLEASE RUN source ~/.bashrc, in order for changes to take effect"

