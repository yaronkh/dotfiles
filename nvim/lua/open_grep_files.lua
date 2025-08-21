local api = vim.api

local function is_buffer_opened(filepath)
        for _, buf in ipairs(api.nvim_list_bufs()) do
                if api.nvim_buf_is_loaded(buf) and api.nvim_buf_get_name(buf) == filepath then
                        return true
                end
        end
        return false
end

local function open_grep_files(search_str)
        local original_buf = api.nvim_get_current_buf()
        local cwd = vim.fn.getcwd()
        local rg_cmd = string.format("rg --files-with-matches --no-messages --hidden --glob '!.git/*' %q", search_str)
        local handle = io.popen(rg_cmd)
        if not handle then return end
        local result = handle:read("*a")
        handle:close()

        for filepath in result:gmatch("[^\r\n]+") do
                local abs_path = vim.fn.fnamemodify(filepath, ":p")
                if not is_buffer_opened(abs_path) then
                        vim.cmd("edit " .. abs_path)
                end
        end

        api.nvim_set_current_buf(original_buf)
end

return open_grep_files
