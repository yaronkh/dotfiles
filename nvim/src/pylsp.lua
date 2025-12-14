-- go get the good and full list of configurations us this file
-- pylsp/config/scheme.json
local conf_file = vim.env.HOME .. "/dotfiles/pylint.rc"
local line_length = 180
vim.lsp.config.pylsp = {
        -- capabilities = restricted_capabilities,
        settings = {
                pylsp = {
                        plugins = {
                                jedi_definition = { enabled = false },
                                jedi_references = { enabled = false },
                                flake8 = { enabled = true, config = string.format("max-line-length = %d", line_length)},
                                pylint = { enabled = false, args = { string.format("--max-line-length=%d", line_length), "--rcfile=" .. conf_file} },
                                rope_autoimport = { enabled = false },
                                pycodestyle = { ignore = {'W391', 'W191'}, maxLineLength = line_length },
                                black = { enabled = true , line_length = line_length},
                        }
                }
        }
}

-- we are not using gogo definition as well as references, this we take from pyright

vim.lsp.enable("pylsp", true)
