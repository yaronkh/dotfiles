call plug#begin()

"window manipulation plugin,
"enable to move buffers between tabs,
"exchange buffers between windows,
"easy window navigation and duplicate buffers across windows
Plug 'yaronkh/vim-winmanip'

"
" vimspector - debugger front end for debugger. In particular it is used for
" gdb and debugpy
Plug 'puremourning/vimspector'

" align text in old c-style fashin style
Plug 'junegunn/vim-easy-align'

" enable tag search in all opened buffers
Plug 'vim-scripts/taglist.vim'

" file system explorer for vim editor
Plug 'scrooloose/nerdtree'

" manages nerdtree and taglist in single system ui
" presee C-L to toggle that view
Plug 'wesleyche/Trinity'

" cpp completions with ctags database (created in gutentags and
" gutentags_plus)
Plug 'vim-scripts/OmniCppComplete'

" function libraries used by other plugins
Plug 'tomtom/tlib_vim'
"Plug 'rdolgushin/snipMate-acp'

" opens completion popup when certain characters are typed
Plug 'vim-scripts/AutoComplPop'

" manages tag files under ~/.cache/tags
Plug 'ludovicchabant/vim-gutentags', { 'do': 'chmod a+x ./plat/unix/*.sh' }

" expands vim-gutentags so files from multiple projects
Plug 'skywind3000/gutentags_plus'

" enable fzf functions in vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Opens and navigate through alternate files
" for example, if you are on c file and want todo
" open the corresponding h files in vertical split, just run :AV
Plug 'vim-scripts/a.vim'

" fancy tabline and statusline that light according to edit mode
Plug 'vim-airline/vim-airline'

" run things asynchronous
Plug 'skywind3000/asyncrun.vim'

" Plug 'brandonbloom/csearch.vim'
"Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'

" retro style for vim`
Plug 'morhetz/gruvbox'

" highlight tags in code
Plug 'vim-scripts/TagHighlight'

" enable virtual selection of code block
" for example, enter into virtual selection mode (press v)
" than, press + for expand the selection and _ for shrink it back
Plug 'terryma/vim-expand-region'

" additional vim c++ syntax highlighting
" this includes c++11/14/17 and much more
Plug 'octol/vim-cpp-enhanced-highlight'

" basic plugin that provides many misc functionality
" for example, run functions asynchrounously, periodic call and more
Plug 'xolox/vim-misc'

" plugin for resizing window, Pres C-E and start playing
Plug 'simeji/winresizer'
"Plug 'vim-scripts/DetectIndent'
"
"A Vim plugin which shows a git diff in the sign column
Plug 'airblade/vim-gitgutter'

" This plugin causes all trailing whitespace characters to be highlighted.
Plug 'ntpeters/vim-better-whitespace'

" spelling plugin. spells comments and strings in code
" to fix words, place the cursor on a problematic word and press z=
Plug 'me-vlad/spellfiles.vim'
"Plug 'sakhnik/nvim-gdbm'

" plugin around gdb, this plugin is deprecated in favor
" of vimspector
Plug 'cpiger/NeoDebug'

" show marks and bookmarks in the sign side coloumn
Plug 'kshenoy/vim-signature'

" detect linux kernel code and mark code that
" violates linux coding style
" Plug 'vivien/vim-linux-coding-style'

" code completer for python, that uses jedi library
" I've exanded that to include 'goto-definition' and
" where used
Plug 'davidhalter/jedi-vim'

" plugin to python debugger. This plugin is deprecated
" in favor of vimspector with debugpy
Plug 'gotcha/vimpdb'

" a wrapper around git. for example, :GBlame will show
" git blame window to the left
Plug 'tpope/vim-fugitive'

"ALE (Asynchronous Lint Engine)
"is a plugin providing linting (syntax checking and semantic errors) in NeoVim 0.2.0+
"it checks your code interactively and shows error mark in the sign coloum`
Plug 'dense-analysis/ale'

" collection of files that uses fzf. For example FZFTags and FZFWindows
"Plug 'yuki-ycino/fzf-preview.vim' { 'branch': 'release', 'do': ':UpdateRemotePlugins' }

" great plugin for creating commits in vim. just type :Magit
" get help in the new window by pressing ?
Plug 'jreybert/vimagit'
Plug 'artur-shaik/vim-javacomplete2'

" presonal wiki for vim. similar to emacs org
Plug 'vimwiki/vimwiki'

" adds todo funcionality for vimwiki
Plug 'aserebryakov/vim-todo-lists'

" adds cpp competions with clang ide assistant (great)
Plug 'justmao945/vim-clang'

" aws smithy language syntax highlight
Plug 'jasdel/vim-smithy'

Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" typescript omnicomplete and goto definition
Plug 'Quramy/tsuquyomi'

" Vim plugin for insert mode completion of words in adjacent tmux panes
Plug 'wellle/tmux-complete.vim'

" Semshi provides semantic highlighting for Python in Neovim
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }

call plug#end()
