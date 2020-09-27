" Plug
" Folder in which script resides: (not safe for symlinks)
let g:HomePath = fnameescape(fnamemodify('~', ':p'))
let g:sp_config_dir = glob(expand("<sfile>:p:h"))
exe ':source ' . g:HomePath . 'dotfiles/nvim/src/init.vim'
