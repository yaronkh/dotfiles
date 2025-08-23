local M = {}
local lsyncd_job_id = nil
local lsyncd_cfg = nil
local tgt_host = ""

-- Setup function: pass in lsyncd configuration file path
function M.setup(cfg_path, target_host)
        lsyncd_cfg = cfg_path
        tgt_host = target_host or ""
        vim.fn.setenv("TGT_HOST", tgt_host)
end

-- Start function: launches lsyncd in the background
function M.start()
        if lsyncd_job_id then
                vim.notify("lsyncd is already running", vim.log.levels.WARN)
                return
        end
        if not lsyncd_cfg then
                vim.notify("lsyncd config file not set. Use setup(cfg_path)", vim.log.levels.ERROR)
                return
        end
        lsyncd_job_id = vim.fn.jobstart({ "lsyncd", lsyncd_cfg }, {
                detach = true,
                pty = false,
                on_exit = function(_, code, _)
                        vim.print(vim.inspect(lsyncd_cfg))
                        lsyncd_job_id = nil
                end,
        })
        if lsyncd_job_id <= 0 then
                vim.notify("Failed to start lsyncd", vim.log.levels.ERROR)
                lsyncd_job_id = nil
        end
end

-- End function: stops lsyncd process
function M.stop()
        if not lsyncd_job_id then
                vim.notify("lsyncd is not running", vim.log.levels.WARN)
                return
        end
        vim.fn.jobstop(lsyncd_job_id)
        lsyncd_job_id = nil
        vim.notify("lsyncd stopped", vim.log.levels.INFO)
end

-- Autocmd to kill lsyncd when Neovim exits
vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
                if lsyncd_job_id then
                        vim.fn.jobstop(lsyncd_job_id)
                        lsyncd_job_id = nil
                end
        end,
})

-- Command: LSD {start|stop}
vim.api.nvim_create_user_command("LSD", function(opts)
        local arg = opts.args and opts.args:lower()
        if arg == "start" then
                M.start()
        elseif arg == "stop" then
                M.stop()
        else
                vim.notify('Usage: :LSD start|stop', vim.log.levels.WARN)
        end
end, {
        nargs = 1,
        complete = function(_, line)
                return { "start", "stop" }
        end,
})

return M
