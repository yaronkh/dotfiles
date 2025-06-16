-- h files are c not cpp
vim.g.c_syntax_for_h = 1
vim.g.c_comment_strings = 1
vim.g.c_space_errors = 1
vim.lsp.config("clangd", {
        cmd = {
                -- see clangd --help-hidden
                "clangd",
                "--background-index",
                "--enable-config",
                --"--clang-tidy",
                -- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
                -- to add more checks, create .clang-tidy file in the root directory
                -- and add Checks key, see https://clang.llvm.org/extra/clang-tidy/
                "--completion-style=bundled",
                "--header-insertion=iwyu",
                "--limit-references=10000",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--log=verbose",
        },
        root_markers = { '.git' },
        filetypes = { 'c', 'cpp', 'cuda', 'objc', 'objcpp', },
        capabilities = {
                textDocument = {
                        completion = {
                                editsNearCursor = true,
                        },
                },
                offsetEncoding = { 'utf-8', 'utf-16' },
        },
})
--vim.lsp.enable("clangd", true)

