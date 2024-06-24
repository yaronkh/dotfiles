local builtin = require('telescope.builtin')

function vim.getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg('v')
	vim.fn.setreg('v', {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ''
	end
end

vim.keymap.set('n', ',f', builtin.find_files, { desc = "Find Files"})
vim.keymap.set('n', ',g', "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = "Live Grep"})
vim.keymap.set('v', ',g',
    function()
            local text = vim.getVisualSelection()
            builtin.live_grep({ default_text = text }) end,
    { noremap = true, silent = true, desc = "Live Grep visual selected" }
)
vim.keymap.set('n', ',c', '<cmd>lua require("telescope.builtin").live_grep({ glob_pattern = "!{spec,test}"})<CR>', { desc = "Live Grep Code"})
vim.keymap.set('n', ',b', builtin.buffers, { desc = "Find Buffers"})
vim.keymap.set('n', '<leader><enter>', builtin.buffers, { desc = "Find Buffers"})
vim.keymap.set('n', ',<enter>', builtin.buffers, { desc = "Find Buffers"})
vim.keymap.set('n', ',h', builtin.help_tags, { desc = "Find Help Tags"})
vim.keymap.set('n', ',s', builtin.lsp_document_symbols, { desc = "Find Symbols"})
vim.keymap.set('n', ',v', builtin.lsp_dynamic_workspace_symbols, { desc = "Symbols from all included"})
vim.keymap.set('n', ',d', '<cmd>Telescope ctags_outline<CR>', { desc = "Show buffer symbols with ctags"})
vim.keymap.set('n', ',x', '<cmd>Telescope tags<CR>', { desc = "Show symbols from all files recursively"})
vim.keymap.set('n', ',e', '<cmd>Telescope diagnostics<CR>', { desc = "Show all code diagnostics problem"})
vim.keymap.set('n', ',i', '<cmd>AdvancedGitSearch<CR>', { desc = "AdvancedGitSearch"})
vim.keymap.set('n', ',o', builtin.oldfiles, { desc = "Find Old Files"})
vim.keymap.set('n', ',w', builtin.grep_string, { desc = "Find Word under Cursor"})
vim.keymap.set('n', ',q', '<cmd>Telescope quickfix<CR>', { desc = "move quickfix content to telescope"})
vim.keymap.set('n', ',a', '<cmd>Telescope quickfixhistory<CR>', { desc = "show quickfix history in telescope"})
vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = "Search Git Commits"})
vim.keymap.set('n', '<leader>gb', builtin.git_bcommits, { desc = "Search Git Commits for Buffer"})
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
    layout_config = { width = 0.7 }
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local telescope = require("telescope")
local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

local actions = require "telescope.actions"

local select_one_or_multi = function(prompt_bufnr)
    local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
    local multi = picker:get_multi_selection()
    if not vim.tbl_isempty(multi) then
        require('telescope.actions').close(prompt_bufnr)
        for _, j in pairs(multi) do
            if j.path ~= nil then
                vim.cmd(string.format("%s %s", "edit", j.path))
            end
        end
    else
        require('telescope.actions').select_default(prompt_bufnr)
    end
end

telescope.setup({
    defaults = {
        -- `hidden = true` is not supported in text grep commands.
        vimgrep_arguments = vimgrep_arguments,
        path_display = { "truncate" },
        mappings = {
            n = {
                ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
            i = {
                ["<C-j>"] = actions.cycle_history_next,
                ["<C-k>"] = actions.cycle_history_prev,
                ["<CR>"] = select_one_or_multi,
                ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["<C-S-d>"] = actions.delete_buffer,
            }
        },
    },
    pickers = {
        find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
    },
    extensions = {
        undo = {
            use_delta = true,
            use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
            side_by_side = false,
            diff_context_lines = vim.o.scrolloff,
            entry_format = "state #$ID, $STAT, $TIME",
            mappings = {
                i = {
                    ["<C-cr>"] = require("telescope-undo.actions").yank_additions,
                    ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
                    ["<cr>"] = require("telescope-undo.actions").restore,
                },
            },
        },
    }
})

require("telescope").load_extension "neoclip"

require('telescope').load_extension('fzf')

require('telescope').load_extension('ui-select')
vim.g.zoxide_use_select = true

require("telescope").load_extension("undo")

require("telescope").load_extension("advanced_git_search")

require("telescope").load_extension("live_grep_args")

-- require("telescope").load_extension("colors")

require("telescope").load_extension("noice")
