return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate'
    },

    -- Example: Adding another plugin from GitHub
    'tpope/vim-fugitive',

    -- You can also include configuration options in a table format:
    {
        'neovim/nvim-lspconfig',
    },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

    {'ellisonleao/gruvbox.nvim', lazy = false,},
    'github/copilot.vim',
    'nvim-lua/plenary.nvim',
    'CopilotC-Nvim/CopilotChat.nvim',
    'itmammoth/doorboy.vim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'yaronkh/vim-winmanip',
    --  find and manage project root
    'dbakker/vim-projectroot',
    --  vimspector - debugger front end for debugger. In particular it is used for
    --  gdb and debugpy
    'puremourning/vimspector',
    --  align text in old c-style fashion style
    'junegunn/vim-easy-align',
    -- to aling with vim-easy-align to char '=' run :EasyAlign =
    'mhinz/vim-startify',
    --  enable tag search in all opened buffers
    'vim-scripts/taglist.vim',
    'preservim/nerdtree',
    'tiagofumo/vim-nerdtree-syntax-highlight',
    'Xuyuanp/nerdtree-git-plugin',
    --  function libraries used by other plugins
    'tomtom/tlib_vim',
    --  manages tag files under ~/.cache/tags
    'ludovicchabant/vim-gutentags',
    'junegunn/fzf',
    "junegunn/fzf.vim",
    --  open the corresponding h files in vertical split, just run :AV
    'vim-scripts/a.vim',
    --  fancy tabline and statusline that light according to edit mode
    'vim-airline/vim-airline',
    'vim-airline/vim-airline-themes',
    --  run things asynchronou
    'skywind3000/asyncrun.vim',
    'majutsushi/tagbar',
    --  highlight tags in code
    'vim-scripts/TagHighlight',
    --  enable virtual selection of code block
    --  for example, enter into virtual selection mode (press v)
    --  than, press + for expand the selection and _ for shrink it back
    'terryma/vim-expand-region',
    --  additional vim c++ syntax highlighting
    --  this includes c++11/14/17 and much more
    'octol/vim-cpp-enhanced-highlight',
    --  basic plugin that provides many misc functionality
    --  for example, run functions asynchrounously, periodic call and more
    'xolox/vim-misc',
    --  plugin for resizing window, Pres C-E and start playing
    'simeji/winresizer',
    -- A Vim plugin which shows a git diff in the sign column
    'airblade/vim-gitgutter',
    -- vim osc52 support (copy/paste)
    'ShikChen/osc52.vim',
    --  plugin around gdb, this plugin is deprecated in favor
    --  of vimspector
    'cpiger/NeoDebug',
    --  show marks and bookmarks in the sign side coloumn
    'kshenoy/vim-signature',
    -- ALE (Asynchronous Lint Engine)
    'dense-analysis/ale',
    --  great plugin for creating commits in vim. just type :Magit
    --  get help in the new window by pressing ?
    'jreybert/vimagit',
    --  presonal wiki for vim. similar to emacs org
    'vimwiki/vimwiki',
    --  adds cpp competions with clang ide assistant (great)
    {
        'aznhe21/actions-preview.nvim',
        config = function()
            vim.keymap.set({ "v", "n" }, "ge", require("actions-preview").code_actions)
        end,
    },
    'junegunn/seoul256.vim',
    --  Vim plugin for insert mode completion of words in adjacent tmux panes
    'wellle/tmux-complete.vim',
    --  Surround.vim is all about "surroundings": parentheses, brackets, quotes, XML tags, and more
    'tpope/vim-surround',
    'stevearc/dressing.nvim',
    --  maven syntax highlight (for pom.xml files)
    'NLKNguyen/vim-maven-syntax',
    'kevinhwang91/nvim-bqf',
    -- debugger interface
    -- use "mfussenegger/nvim-dap.git"
    {
        'rcarriga/nvim-dap-ui',
        dependencies = {
            'mfussenegger/nvim-dap',
            'nvim-neotest/nvim-nio',
        }
    },
    -- gisignes, show git changes in sign column and able to show git information inline
    'lewis6991/gitsigns.nvim',
    'nvim-treesitter/playground',
    'nvim-tree/nvim-web-devicons',
    { 'nvim-mini/mini.nvim',                      version = '*' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'bash -c "cd ~/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim && CC=gcc make > ~/.makeit"' },
    'nvim-telescope/telescope-ui-select.nvim',
    'OXY2DEV/helpview.nvim',
    {
        'nvim-telescope/telescope.nvim',
        dependencies =
        { "nvim-tree/nvim-web-devicons" },
        { "nvim-telescope/telescope-live-grep-args.nvim" },
        { "Marskey/telescope-sg" },
        { "debugloop/telescope-undo.nvim" },
        { "AckslD/nvim-neoclip.lua" },
        { "aaronhallaert/advanced-git-search.nvim" },
        { "folke/noice.nvim" },
        { "fcying/telescope-ctags-outline.nvim" },
        config = function()
            require("telescope").load_extension("live_grep_args")
        end
    },
    'python-lsp/python-lsp-black',
    'Marskey/telescope-sg',
    'onsails/lspkind.nvim',
    'hrsh7th/cmp-path',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'uga-rosa/cmp-dictionary',
    'f3fora/cmp-spell',
    'lukas-reineke/cmp-rg',
    'hrsh7th/cmp-omni',
    'amarz45/nvim-cmp-buffer-lines',
    'hrsh7th/cmp-buffer',
    'andersevenrud/cmp-tmux',
    'ray-x/cmp-treesitter',
    'delphinus/cmp-ctags',
    'hrsh7th/cmp-nvim-lsp-signature-help',
}
