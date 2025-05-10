--require("cmp").setup({
--        sources = require("cmp").config.sources(
--                -- {{name ="codeium"}},
--                -- {{name = "nvim_lsp"}},
--                -- {{ name = "path" }},
--                -- {{ name = "Omni" }},
--                -- -- {{ name = "dictionary" }},
--                -- -- {{ name = "spell" }},
--                -- -- {{ name = "rg" }},
--                -- {{ name = "cmdline"}}
--        ),
--        formatting = {
--                format = require('lspkind').cmp_format({
--                        mode = "symbol",
--                        maxwidth = 50,
--                        ellipsis_char = '...',
--                        symbol_map = { Codeium = "", }
--                })
--        }
--})
--
local cmp = require'cmp'

cmp.setup({
        --snippet = {
                --        -- REQUIRED - you must specify a snippet engine
                --        expand = function(args)
                        --                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                        --                -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        --                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        --                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                        --                -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

                        --                -- For `mini.snippets` users:
                        --                -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
                        --                -- insert({ body = args.body }) -- Insert at cursor
                        --                -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
                        --                -- require("cmp.config").set_onetime({ sources = {} })
                        --        end,
                        --},
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
                                { name = "path" },
                                { name = 'cmdline' },
                                -- { name ='buffer-lines' },
                                -- { name = 'cmd' },
                                { name = 'spell' },
                                { name = 'tmux' },
                                { name = "codeium" },
                                -- { name = 'rg' },
                                { name = 'buffer' },
                        --        -- { name = 'vsnip' }, -- For vsnip users.
                        --        -- { name = 'luasnip' }, -- For luasnip users.
                        --        -- { name = 'ultisnips' }, -- For ultisnips users.
                        --        -- { name = 'snippy' }, -- For snippy users.
                        --},
                        --{
                        --        --{ name = 'buffer' },
                        }),
                        formatting = {
                                format = require('lspkind').cmp_format({
                                        mode = "symbol",
                                        maxwidth = 50,
                                        ellipsis_char = '...',
                                        symbol_map = {Codeium = ""}
                                })
                        }

  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
                  { name = 'git' },
          }, {
                  { name = 'buffer' },
          })
  })
  require("cmp_git").setup() ]]--

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

  -- Set up lspconfig.
  --local capabilities = require('cmp_nvim_lsp').default_capabilities()
  ---- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  --require('lspconfig')['clangd'].setup {
  --        capabilities = capabilities
  --}

  -- Set up nvim-cmp.
require("codeium").setup({
    -- Optionally disable cmp source if using virtual text only
    enable_cmp_source = false,
    virtual_text = {
        enabled = true,

        -- These are the defaults

        -- Set to true if you never want completions to be shown automatically.
        manual = false,
        -- A mapping of filetype to true or false, to enable virtual text.
        filetypes = {},
        -- Whether to enable virtual text of not for filetypes not specifically listed above.
        default_filetype_enabled = true,
        -- How long to wait (in ms) before requesting completions after typing stops.
        idle_delay = 75,
        -- Priority of the virtual text. This usually ensures that the completions appear on top of
        -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
        -- desired.
        virtual_text_priority = 65535,
        -- Set to false to disable all key bindings for managing completions.
        map_keys = true,
        -- The key to press when hitting the accept keybinding but no completion is showing.
        -- Defaults to \t normally or <c-n> when a popup is showing.
        accept_fallback = nil,
        -- Key bindings for managing completions in virtual text mode.
        key_bindings = {
            -- Accept the current completion.
            accept = "<M-.>",
        --    -- Accept the next word.
            accept_word = "<M-'>",
        --    -- Accept the next line.
        --    accept_line = false,
        --    -- Clear the virtual text.
        --    clear = false,
        --    -- Cycle to the next completion.
        --    next = "<M-]>",
        --    -- Cycle to the previous completion.
        --    prev = "<M-[>",
        }
    }
})

vim.g.codeium_token = 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjNmOWEwNTBkYzRhZTgyOGMyODcxYzMyNTYzYzk5ZDUwMjc3ODRiZTUiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiWWFyb24gS2FoYW5vdml0Y2giLCJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZXhhMi1mYjE3MCIsImF1ZCI6ImV4YTItZmIxNzAiLCJhdXRoX3RpbWUiOjE3NDY2OTAwMDYsInVzZXJfaWQiOiJEdGtBb0xCT1dSWmZteXgwQmxlczdDbUdCY24xIiwic3ViIjoiRHRrQW9MQk9XUlpmbXl4MEJsZXM3Q21HQmNuMSIsImlhdCI6MTc0NjY5MzI2OSwiZXhwIjoxNzQ2Njk2ODY5LCJlbWFpbCI6InlrYWhhbm92aXRjaEBudmlkaWEuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsic2FtbC5udmlkaWEiOlsieWthaGFub3ZpdGNoQG52aWRpYS5jb20iXSwiZW1haWwiOlsieWthaGFub3ZpdGNoQG52aWRpYS5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJzYW1sLm52aWRpYSIsInNpZ25faW5fYXR0cmlidXRlcyI6eyJmaXJzdE5hbWUiOiJZYXJvbiIsImxhc3ROYW1lIjoiS2FoYW5vdml0Y2giLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL2lkZW50aXR5L2NsYWltcy9kaXNwbGF5bmFtZSI6Illhcm9uIEthaGFub3ZpdGNoIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS9pZGVudGl0eS9jbGFpbXMvdGVuYW50aWQiOiI0MzA4M2QxNS03MjczLTQwYzEtYjdkYi0zOWVmZDljY2MxN2EiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL2lkZW50aXR5L2NsYWltcy9pZGVudGl0eXByb3ZpZGVyIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvNDMwODNkMTUtNzI3My00MGMxLWI3ZGItMzllZmQ5Y2NjMTdhLyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vaWRlbnRpdHkvY2xhaW1zL29iamVjdGlkZW50aWZpZXIiOiJjMDU2ZTE1MC05YjhjLTRkNmYtOWU1Ni0zNjllY2QyM2I3YzUiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9naXZlbm5hbWUiOiJZYXJvbiIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJ5a2FoYW5vdml0Y2hAbnZpZGlhLmNvbSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vY2xhaW1zL2F1dGhubWV0aG9kc3JlZmVyZW5jZXMiOlsiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2F1dGhlbnRpY2F0aW9ubWV0aG9kL3Bhc3N3b3JkIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS9jbGFpbXMvbXVsdGlwbGVhdXRobiJdLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9zdXJuYW1lIjoiS2FoYW5vdml0Y2giLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJ5a2FoYW5vdml0Y2hAbnZpZGlhLmNvbSJ9fX0.s3VoAerPc17NgwuRAdF1vb8L4R3tAhOwW5uG8e_LTSmbJjcElJks98emB_poG55aT_hi7HM1T7bNeqSI9VAiisQ9O3lE1gM4mNQumIIaWrNeGvLBhS-ycuhgjsjeVAfOVqN3pVKjXfWJgXnBgH04toRJu7aR0mExNnvndbt4gkMFkgz9hnnsTZuj1aNcG_Hqk5xx5tuvh0Bu4fITnUwcJt0hyFD417ndCZ9pGao8xilZy8d5wkLzoitrViIapEWgONA0mzn8SUXk1lrxcLc8QSBVLivU67JcOx9i7pFT7Q1yc7HAuoeuwxvRwxR3QIyCWjZq9mbnTrTRMmASd9icHw'

--local cmp = require("cmp")

