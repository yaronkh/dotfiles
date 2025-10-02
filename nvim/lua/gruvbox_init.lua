-- Default options for gruvbox
require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
                strings = true,
                emphasis = true,
                comments = true,
                operators = false,
                folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        inverse = true,    -- invert background for search, diffs, statuslines and errors
        contrast = "hard", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        dim_inactive = false,
        transparent_mode = true,
        overrides = {
                Comment = { bg = "gray", fg = "black" },
                Normal = { bg = "black", fg = "white" },
                --String = vim.api.nvim_get_hl(0, {name = "GruvboxRed"}),
                String = { bg = "orange", fg = "black" },
                Visual = { fg = "white" },
        },
})

-- Apply the gruvbox colorscheme
vim.cmd("colorscheme gruvbox")

