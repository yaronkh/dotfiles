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
                Comment = { fg = "gray", bg = "black" },
                Normal = { bg = "black", fg = "white" },
                String = { fg = "orange", bg = "black" },
                Visual = { bg = "white" },
        },
})

-- Apply the gruvbox colorscheme
vim.cmd("colorscheme gruvbox")

function ShowHighlightUnderCursor()
  -- Get the current cursor position
  local line = vim.fn.line('.')
  local col = vim.fn.col('.')

  -- Get the syntax ID at the given position
  local synID = vim.fn.synID(line, col, true)

  -- Get the highlight group ID
  local hlID = vim.fn.synIDtrans(synID)

  -- Get the name of the highlight group
  local hlName = vim.fn.synIDattr(hlID, "name")

  -- Get the highlight group details
  local hl = vim.api.nvim_get_hl(0, {name = hlName}) -- true for RGB colors

  -- Extract the color components
  local color = {
    fg = hl.foreground and string.format("#%06x", hl.foreground) or "none",
    bg = hl.background and string.format("#%06x", hl.background) or "none",
    sp = hl.special and string.format("#%06x", hl.special) or "none"
  }

  print(string.format("Highlight group: %s", hlName))
  print(string.format("Foreground: %s", color.fg))
  print(string.format("Background: %s", color.bg))
  print(string.format("Special: %s", color.sp))
end

-- Create a Vim command to call the function
vim.api.nvim_create_user_command('ShowHi', function()
  ShowHighlightUnderCursor()
end, { nargs = 0 })
