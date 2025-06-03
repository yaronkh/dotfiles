-- go get the good and full list of configurations us this file
-- pylsp/config/scheme.json
vim.lsp.config.pylsp = {
        -- capabilities = restricted_capabilities,
        settings = {
                pylsp = {
                        plugins = {
                                jedi_definition = { enabled = false },
                                jedi_references = { enabled = false },
                                flake8 = { enabled = true, config = "max-line-length = 120" },
                                pylint = { enabled = true, args = { "--max-line-length=120" } },
                                rope_autoimport = { enabled = true },
                                pycodestyle = { ignore = {'W391'}, maxLineLength = 120 },
                                black = { enabled = true , line_length = 120 },
                        }
                }
        }
}

-- we are not using gogo definition as well as references, this we take from pyright

vim.lsp.enable("pylsp", true)
