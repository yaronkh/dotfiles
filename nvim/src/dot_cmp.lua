
local cmp = require'cmp'
local lspkind = require('lspkind')

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),         -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = "path" },
        { name = 'cmd' },
        { name = 'spell' },
        { name = 'tmux' },
        { name = 'buffer' },
        { name = 'treesitter' },
    }),
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol', -- show only symbol annotations
            maxwidth = {
                -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                -- can also be a function to dynamically calculate max width such as
                -- menu = function() return math.floor(0.45 * vim.o.columns) end,
                menu = 50,      -- leading text (labelDetails)
                abbr = 50,      -- actual suggestion item
            },
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
                -- ...
                return vim_item
            end
        })
    }
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

-- enable cmp capabilities to all lsp configs in one sentence
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('*', { capabilities = capabilities})
