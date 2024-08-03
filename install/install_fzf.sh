#/bin/bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

sed -i 's/fzf --bash/command fzf --bash/g'  .fzf.bash
