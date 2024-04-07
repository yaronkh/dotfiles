local dap = require("dap")

-- C/C++/Rust (via gdb)
dap.defaults.fallback.external_terminal = {
        command = '/usr/bin/alacritty';
        args = {'-e'};
}

function rebugger (args)
        local dap = require "dap"
        local last_gdb_config = {
                type = "cpp",
                name = args[1],
                request = "launch",
                program = table.remove(args, 1),
                args = args,
                cwd = vim.fn.getcwd(),
                env = {"NO_COLOR=1"},
                console = "externalTerminal",
                externalTerminal = true,
                externalConsole = true,
        }
        dap.run(last_gdb_config)
        dap.repl.open()
end

vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = "debug continue"})
vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = "debug step over"})
vim.keymap.set('n', '<Leader><F11>', function() dap.step_into() end, { desc = "debug step into"})
vim.keymap.set('n', '<Leader><F12>', function() dap.step_out() end, { desc = "debug step out"})
vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end, { desc = "debug toggle breakpoint"})
vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end, { desc = "debug toggle breakpoint"})
vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint() end, { desc = "debug set breakpoint"})
vim.keymap.set('n', '<Leader>dB', function() dap.set_breakpoint() end, { desc = "debug set breakpoint"})
vim.keymap.set('n', '<Leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "debug set log breakpoint"})
vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end, { desc = "debug open repl"})
vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end, { desc = "debug run last"})
vim.keymap.set('n', '<Leader>dsi', function() dap.step_into() end, { desc = "debug step into"})
vim.keymap.set('n', '<Leader>dso', function() dap.step_out() end, { desc = "debug step out"})
vim.keymap.set('n', '<Leader>dt', function() dap.terminate() end, { desc = "terminate debug session"})
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
        require('dap.ui.widgets').hover()
end, { desc = "debug hover"})
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
        require('dap.ui.widgets').preview()
end, { desc = "debug preview"})
vim.keymap.set('n', '<Leader>df', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
end, { desc = "debug frames"})
vim.keymap.set('n', '<Leader>dsc', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
end, { desc = "debug scopes"})

local ok, dap = pcall(require, 'dap')
if not ok then
        return
end

-- if vim.fn.executable('gdb') == 1 then
--        require('plugins.dap.c')
-- end
--
-- See
-- https://sourceware.org/gdb/current/onlinedocs/gdb.html/Interpreters.html
-- https://sourceware.org/gdb/current/onlinedocs/gdb.html/Debugger-Adapter-Protocol.html
dap.adapters.gdb = {
        id = 'gdb',
        type = 'executable',
        command = 'gdb',
        runInTerminal = true,
        args = { '--quiet', '--interpreter=dap' },
}

dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode-15', -- adjust as needed, must be absolute path
        name = 'lldb'
}

dap.adapters.codelldb = {
  type = 'server',
  port = "13123",
  executable = {
    -- CHANGE THIS to your path!
    command = '/home/ykahanovitch/stuff/codelldp/extension/adapter/codelldb',
    args = {"--port", "13123"},

    -- On windows you may have to uncomment this:
    -- detached = false,
  }
}

dap.configurations.c = {
        {
                name = 'Run executable (GDB)',
                type = 'gdb',
                request = 'launch',
                -- This requires special handling of 'run_last', see
                -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
                program = function()
                        local path = vim.fn.input({
                                prompt = 'Path to executable: ',
                                default = vim.fn.getcwd() .. '/',
                                completion = 'file',
                        })

                        return (path and path ~= '') and path or dap.ABORT
                end,
        },
        {
                name = 'Run executable with arguments (GDB)',
                type = 'gdb',
                request = 'launch',
                -- This requires special handling of 'run_last', see
                -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
                program = function()
                        local path = vim.fn.input({
                                prompt = 'Path to executable: ',
                                default = vim.fn.getcwd() .. '/',
                                completion = 'file',
                        })

                        return (path and path ~= '') and path or dap.ABORT
                end,
                args = function()
                        local args_str = vim.fn.input({
                                prompt = 'Arguments: ',
                        })
                        return vim.split(args_str, ' +')
                end,
        },
        {
                name = 'Attach to process (GDB)',
                type = 'gdb',
                request = 'attach',
                processId = require('dap.utils').pick_process,
        },
        {
                name = 'Run executable (LLDB)',
                type = 'lldb',
                request = 'launch',
                program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = {},
                runInTerminal = true,
                console = "externalTerminal",
                externalTerminal = true,
                externalConsole = true,
        },
        {
                name = "Launch file (codelldb)",
                type = "codelldb",
                request = "launch",
                program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                terminal = "external",
        },
}

--codelldb manual: https://github.com/vadimcn/codelldb/blob/master/MANUAL.md

vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
require("dapui").setup()
