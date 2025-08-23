local clangd_setup = {}

local active_clangd_globally = function()
        local active_clients = vim.lsp.get_clients()
        for _, client in ipairs(active_clients) do
                if client.name == "clangd" then
                        return client.id
                end
        end
        return nil
end

vim.g.sync_started = false

local function on_vim_leave()
        if vim.g.sync_started then
                local sync_path = vim.fn.expand("~/dotfiles/utils/sync_files.sh")
                local obj = vim.system({ "/bin/bash", sync_path, "stop" }):wait()
                if string.find(obj.stdout, "Stopping") then
                        vim.g.sync_started = false
                end
        end
end

vim.api.nvim_create_autocmd("VimLeave", {
    callback = on_vim_leave,
})

clangd_setup.setup = function(remote)
        -- h files are c not cpp
        vim.g.c_syntax_for_h = 1
        vim.g.c_comment_strings = 1
        vim.g.c_space_errors = 1
        local cmd = {}
        local cmd_remote = { "ssh", "nvme31", }
        local cmd_local = {
                "clangd",
                "--background-index",
                "--enable-config",
                "--completion-style=bundled",
                "--header-insertion=iwyu",
                "--limit-references=10000",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--log=verbose",
        }
        local sync_path = vim.fn.expand("~/dotfiles/utils/sync_files.sh")
        if remote == "yes" then
                local obj = vim.system({ "/bin/bash", sync_path, "start" }):wait()
                if string.find(obj.stdout, "Normal:") then
                        vim.g.sync_started = true
                end
                cmd = vim.list_extend(cmd_remote, cmd_local)
        else
                if vim.g.sync_started then
                        local obj = vim.system({ "/bin/bash", sync_path, "stop" }):wait()
                        if string.find(obj.stdout, "Stopping") then
                                vim.g.sync_started = false
                        end
                end
                cmd = cmd_local
        end
        local cland_id = active_clangd_globally()
        if cland_id ~= nil then
                vim.lsp.stop_client(cland_id)
        end
        vim.lsp.config("clangd", {
                cmd = cmd,
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
        return clang_id
end

return clangd_setup
