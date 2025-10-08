-- go get the good and full list of configurations us this file
-- pylsp/config/scheme.json
vim.lsp.config.pylsp = {
        -- capabilities = restricted_capabilities,
        settings = {
                pylsp = {
                        plugins = {
                                jedi_definition = { enabled = false },
                                jedi_references = { enabled = false },
                                flake8 = { enabled = true, config = "max-line-length = 180" },
                                pylint = { enabled = true, args = { "--max-line-length=180" } },
                                rope_autoimport = { enabled = false },
                                pycodestyle = { ignore = {'W391'}, maxLineLength = 180 },
                                black = { enabled = true , line_length = 180 },
                        }
                }
        }
}

-- we are not using gogo definition as well as references, this we take from pyright

vim.lsp.enable("pylsp", true)
