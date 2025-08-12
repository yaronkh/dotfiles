vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-word)')
vim.keymap.set('i', '<A-]>', '<Plug>(copilot-next)')

-- setup the color scheme of suggestions
vim.api.nvim_create_autocmd({"VimEnter", "ColorScheme"}, {
        callback = function()
                vim.api.nvim_set_hl(0, 'CopilotSuggestion', {
                        fg = '#FFED29',
                        ctermfg = 8,
                        force = true
                })
        end
})
