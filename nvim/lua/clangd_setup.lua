local clangd_setup = {}
local lsyncd = require("lsyncd")

local function check_and_run_build_sh_conf(var)
    local filename = "build_sh_conf"
    local file = io.open(filename, "r")

    if file then
        file:close()

        -- Run the file with bash and capture the output
        local handle = io.popen("bash -c 'source ./build_sh_conf && echo $" .. var .. "'")
        local result = handle:read("*a")
        handle:close()

        -- Trim any trailing newlines or spaces
        result = result:gsub("%s+$", "")
        -- vim.notify("Remote target from build_sh_conf: " .. result)

        return result
    else
        return nil
    end
end
local remote_tgt = check_and_run_build_sh_conf("REMOTE_TGT")
if remote_tgt == nil then
    remote_tgt = "nvme31"
end
lsyncd.setup(vim.fn.expand("~/dotfiles/nvidia/lsync_conf.lua"), remote_tgt)

local running_clnagd_name = nil

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
        local remote_clangd_cmd = check_and_run_build_sh_conf("CLANGD")
        local cmd_remote = { "ssh", remote_tgt, remote_clangd_cmd or "clangd" }
        local local_clangd_cmd = vim.fn.expand("~/.local/share/nvim/mason/bin/clangd")
        local cmd_local_clangd = { local_clangd_cmd }
        local cmd_local = {
                "--background-index",
                "--enable-config",
                "--completion-style=bundled",
                "--header-insertion=iwyu",
                "--limit-references=10000",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--log=info",
        }
        --local sync_path = vim.fn.expand("~/dotfiles/utils/sync_files.sh")
        if remote == "yes" then
                if vim.g.sync_started == false then
                        lsyncd.setup(vim.fn.expand("~/dotfiles/nvidia/lsync_conf.lua"), remote_tgt)
                        lsyncd.start()
                        vim.g.sync_started = true
                end
                cmd = vim.list_extend(cmd_remote, cmd_local)
                running_clnagd_name = "ssh"
        else
                if vim.g.sync_started then
                        lsyncd.stop()
                        vim.g.sync_started = false
                end
                cmd = vim.list_extend(cmd_local_clangd, cmd_local)
                running_clnagd_name = local_clangd_cmd
        end
        local clang_id = active_clangd_globally()
        if clang_id ~= nil then
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

vim.api.nvim_create_user_command('Rclangd', function(opts)
        local id = clangd_setup.setup(opts.args)
        if id then
                vim.cmd("LspRestart clangd")
        end
end, { nargs = 1 })


return clangd_setup
