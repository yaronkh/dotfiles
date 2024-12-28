
local nio = require "nio"
local vim = vim

local function ends_with(str, substring)
        return (str:sub(0-#substring) == substring)
end

local s_mode = false

local function start_build()
        local buf = vim.fn.expand('%:p')
        if (s_mode == true) then
                return
        end
        s_mode = true
        local home = os.getenv "HOME"
        local cmd = string.format('%s/dotfiles/nvidia/run_clang.sh "%s"', home, buf)
        local result = {}
        vim.fn.jobstart(cmd, {
                  on_exit = function()
                          local sout = table.concat(result, "\n")
                          print(sout)
                          if ends_with(sout, "0\n") then
                                  if string.find(sout, "Nothing to be done") == nil then
                                          vim.cmd("LspRestart")
                                  end
                          end
                          s_mode = false
                          -- vim.api.nvim_echo({ { sout, "Normal" } }, false, {})
                  end,
                  on_stdout = function(_, data, _)
                          result[#result + 1] = data[1]
                  end,
                  detach = true,
        })
end

vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*/nvmesh.kernel/*.c",
        callback = start_build,
})

vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*/nvmeshum/app/*.c",
        callback = start_build,
})
