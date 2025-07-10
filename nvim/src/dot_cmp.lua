
local cmp = require'cmp'

cmp.setup({
        window = {
                completion = cmp.config.window. bordered(),
                documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                -- { name = 'nvim_lsp_signature_help' },
                { name = "path" },
                -- { name = 'cmdline' },
                -- { name ='buffer-lines' },
                { name = 'cmd' },
                { name = 'spell' },
                { name = 'tmux' },
                -- { name = "codeium" },
                -- { name = 'rg' },
                { name = 'buffer' },
                { name = 'treesitter' },
                -- {name = 'ctags'},
        }),
        -- formatting = {
        --         format = require('lspkind').cmp_format({
        --                 mode = "symbol",
        --                 maxwidth = 50,
        --                 ellipsis_char = '...',
        --                 symbol_map = {Codeium = ""}
        --         })
        -- }

})

  cmp.setup.filetype('markdown', {
    sources = {},
  })
  cmp.setup.filetype('vimwiki', {
    sources = {},
  })
  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
                  { name = 'git' },
          }, {
                  { name = 'buffer' },
          })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  --cmp.setup.cmdline({ '/', '?' }, {
  --        mapping = cmp.mapping.preset.cmdline(),
  --        sources = {
  --                { name = 'buffer' }
  --        }
  --})

  ---- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  --cmp.setup.cmdline(':', {
  --        mapping = cmp.mapping.preset.cmdline(),
  --        sources = cmp.config.sources({
  --                { name = 'path' }
  --        }, {
  --                { name = 'cmdline' }
  --        }),
  --        matching = { disallow_symbol_nonprefix_matching = false }
  --})

-- enable cmp capabilities to all lsp configs in one sentence
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('*', { capabilities = capabilities})

-- require('lspconfig').clangd.setup {
--         capabilities = capabilities,
-- }

