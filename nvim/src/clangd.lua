require'lspconfig'.clangd.setup{
        cmd = {
                -- see clangd --help-hidden
                "clangd",
                "-ferror-limit=0",
                "--background-index",
                -- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
                -- to add more checks, create .clang-tidy file in the root directory
                -- and add Checks key, see https://clang.llvm.org/extra/clang-tidy/
                "--clang-tidy",
                "--clang-tidy-checks=*",
                "--completion-style=bundled",
                "--cross-file-rename",
                "--header-insertion=iwyu",
                "--limit-references=0",
                "--limit-results=0",
                "--completion-style=detailed",
                "--function-arg-placeholders",
        },
}
