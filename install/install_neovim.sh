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

update_distro_db
install_distro_linters

#install neovim
(
    echo installing neovim
    install_distro_nvim
)

if ! mkdir -p ~/.config/nvim; then echo "cannot create nvim configuration directory"; exit 255; fi
if ! cp -R -u -p nvim ~/.config/; then echo "Cannot copy nvim configuration files"; exit 255; fi

# install bootstrap nvim packages and quit
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

write_to_shrc 'source ~/dotfiles/local/nvim.bash'

echo
echo "PLEASE RUN source ~/.bashrc, in order for changes to take effect"

