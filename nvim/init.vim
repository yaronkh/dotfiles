" Plug
" Folder in which script resides: (not safe for symlinks)
let g:HomePath = fnameescape(fnamemodify('~', ':p'))
exe ':source ' . g:HomePath . 'dotfiles/nvim/src/init.vim'
