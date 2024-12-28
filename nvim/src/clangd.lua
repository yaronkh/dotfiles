require'lspconfig'.clangd.setup{
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
}

