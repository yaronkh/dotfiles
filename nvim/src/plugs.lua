packer = require("packer")
packer.init({
    git = {
        cmd = 'git', -- The base command for git operations
        subcommands = { -- Format strings for git subcommands
          update         = 'pull --ff-only --progress --rebase=false',
          install        = 'clone --depth %i --no-single-branch --progress',
          fetch          = 'fetch --depth 999999 --progress',
          checkout       = 'checkout %s --',
          update_branch  = 'merge --ff-only @{u}',
          current_branch = 'branch --show-current',
          diff           = 'log --color=never --pretty=format:FMT --no-show-signature HEAD@{1}...HEAD',
          diff_fmt       = '%%h %%s (%%cr)',
          get_rev        = 'rev-parse --short HEAD',
          get_msg        = 'log --color=never --pretty=format:FMT --no-show-signature HEAD -n 1',
          submodules     = 'submodule update --init --recursive --progress'
        },
        depth = 1, -- Git clone depth
        clone_timeout = 180, -- Timeout, in seconds, for git clones
        default_url_format = 'https://github.com/%s' -- Lua format string used for "aaa/bbb" style plugins
  },
})
packer.startup(function(use)
    use 'rstacruz/vim-closer'
    use 'wbthomason/packer.nvim'
    -- window manipulation plugin,
    -- enable to move buffers between tabs,
    -- exchange buffers between windows,
    -- easy window navigation and duplicate buffers across windows
    use 'yaronkh/vim-winmanip'

    --  find and manage project root
    use 'dbakker/vim-projectroot'

    --
    --  vimspector - debugger front end for debugger. In particular it is used for
    --  gdb and debugpy
    use 'puremourning/vimspector'

    --  align text in old c-style fashin style
    use 'junegunn/vim-easy-align'

    --  enable tag search in all opened buffers
    use 'vim-scripts/taglist.vim'

    --  file system explorer for vim editor
    use 'scrooloose/nerdtree'

    --  manages nerdtree and taglist in single system ui
    --  presee C-L to toggle that view
    use 'wesleyche/Trinity'

    --  cpp completions with ctags database (created in gutentags and
    --  gutentags_plus)
    -- use 'vim-scripts/OmniCppComplete'

    --  function libraries used by other plugins
    use 'tomtom/tlib_vim'
    -- use 'rdolgushin/snipMate-acp'

    --  opens completion popup when certain characters are typed
    use 'vim-scripts/AutoComplPop'

    --  manages tag files under ~/.cache/tags
    use { 'ludovicchabant/vim-gutentags', run =  'chmod a+x ./plat/unix/*.sh' }

    --  expands vim-gutentags so files from multiple projects
    --  use 'skywind3000/gutentags_plus'

    use {
        'junegunn/fzf.vim',
        requires = { 'junegunn/fzf', run = ':call fzf#install()' }
    }

    --  open the corresponding h files in vertical split, just run :AV
    use 'vim-scripts/a.vim'

    --  fancy tabline and statusline that light according to edit mode
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'

    --  run things asynchronous
    use 'skywind3000/asyncrun.vim'

    --  use 'brandonbloom/csearch.vim'
    -- use 'jiangmiao/auto-pairs'
    use 'majutsushi/tagbar'

    --  retro style for vim`
    use 'morhetz/gruvbox'

    --  highlight tags in code
    use 'vim-scripts/TagHighlight'

    --  enable virtual selection of code block
    --  for example, enter into virtual selection mode (press v)
    --  than, press + for expand the selection and _ for shrink it back
    use 'terryma/vim-expand-region'

    --  additional vim c++ syntax highlighting
    --  this includes c++11/14/17 and much more
    use 'octol/vim-cpp-enhanced-highlight'

    --  basic plugin that provides many misc functionality
    --  for example, run functions asynchrounously, periodic call and more
    use 'xolox/vim-misc'

    --  plugin for resizing window, Pres C-E and start playing
    use 'simeji/winresizer'
    -- use 'vim-scripts/DetectIndent'
    --
    -- A Vim plugin which shows a git diff in the sign column
    use 'airblade/vim-gitgutter'

    --  This plugin causes all trailing whitespace characters to be highlighted.
    use 'ntpeters/vim-better-whitespace'

    --  spelling plugin. spells comments and strings in code
    --  to fix words, place the cursor on a problematic word and press z=
    use 'me-vlad/spellfiles.vim'
    -- use 'sakhnik/nvim-gdbm'

    --  plugin around gdb, this plugin is deprecated in favor
    --  of vimspector
    use 'cpiger/NeoDebug'

    --  show marks and bookmarks in the sign side coloumn
    use 'kshenoy/vim-signature'

    --  detect linux kernel code and mark code that
    --  violates linux coding style
    --  use 'vivien/vim-linux-coding-style'

    --  code completer for python, that uses jedi library
    --  I've exanded that to include 'goto-definition' and
    --  where used
    use 'davidhalter/jedi-vim'

    --  plugin to python debugger. This plugin is deprecated
    --  in favor of vimspector with debugpy
    use 'gotcha/vimpdb'

    --  a wrapper around git. for example, :GBlame will show
    --  git blame window to the left
    use 'tpope/vim-fugitive'

    -- ALE (Asynchronous Lint Engine)
    -- is a plugin providing linting (syntax checking and semantic errors) in NeoVim 0.2.0+
    -- it checks your code interactively and shows error mark in the sign coloum`
    use 'dense-analysis/ale'

    --  collection of files that uses fzf. For example FZFTags and FZFWindows
    -- use 'yuki-ycino/fzf-preview.vim' { 'branch': 'release', 'do': ':UpdateRemotePlugins' }

    --  great plugin for creating commits in vim. just type :Magit
    --  get help in the new window by pressing ?
    use 'jreybert/vimagit'
    --  use 'artur-shaik/vim-javacomplete2'

    --  presonal wiki for vim. similar to emacs org
    use 'vimwiki/vimwiki'

    --  adds cpp competions with clang ide assistant (great)
    -- use 'justmao945/vim-clang'

    --  aws smithy language syntax highlight
    use 'jasdel/vim-smithy'

    use { 'Shougo/vimproc.vim', run = 'make'}

    --  typescript omnicomplete and goto definition
    use 'Quramy/tsuquyomi'

    --  Vim plugin for insert mode completion of words in adjacent tmux panes
    use 'wellle/tmux-complete.vim'

    --  Semshi provides semantic highlighting for Python in Neovim
    use {'numirias/semshi', cmd = 'UpdateRemotePlugins' }

    --  Peekaboo will show you the contents of the registers on the sidebar when you hit " or @ in normal mode
    use 'junegunn/vim-peekaboo'

    --  Surround.vim is all about "surroundings": parentheses, brackets, quotes, XML tags, and more
    use 'tpope/vim-surround'

    --  maven syntax highlight (for pom.xml files)
    use 'NLKNguyen/vim-maven-syntax'

    use {'neoclide/coc.nvim', branch = 'release'}
    use 'theoremoon/coc-plug'
    -- use {'neoclide/coc.nvim',branch = 'release', cmd = 'CocInstall coc-clangd'}

    use 'williamboman/mason.nvim'

    use 'neovim/nvim-lspconfig'
end)

