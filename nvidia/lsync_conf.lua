settings {
   logfile    = "/tmp/lsyncd.log",
   statusFile = "/tmp/lsyncd.status",
   nodaemon   = true,
    statusInterval = 20,
    maxDelays = 0,
    maxProcesses = 1,
}

local exclude_conf_path = os.tmpname()
print("Using exclude file: " .. exclude_conf_path)

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local pipe = io.popen("pwd")
local src = trim(pipe:read("*a"))
pipe:close()
local tgt_host = os.getenv("TGT_HOST")
if not tgt_host then
    error("Environment variable TGT_HOST is not set!")
end

-- Ensure we're at the top directory of the git repository
local function is_git_topdir(dir)
    local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
    local topdir = trim(handle:read("*l"))
    handle:close()
    if not topdir then
        print("Not in a git repository.")
        return false
    end

    if dir ~= topdir then
        print("Current directory (" .. dir .. ") is not the top directory of the git repository (" .. topdir .. ").")
        return false
    end
    return true
end

if not is_git_topdir(src) then
    error("lsyncd must be run from the top directory of the git repository.")
end

-- Ensure target directory exists via SSH before syncing
local function ensure_target_dir()
    local cmd = "ssh " .. tgt_host .. " 'mkdir -p \"" .. src .. "\"'"
    local ret = os.execute(cmd)
    if ret == false then
        error("Failed to create target directory on host " .. tgt_host)
    end
end

ensure_target_dir()

local function generate_exclude_file()
        local source_file_path = ".gitignore"

        local infile = io.open(source_file_path, "rb") -- Open source file in binary read mode
        if not infile then
                print("Error: Could not open source file.")
                return
        end

        local content = infile:read("*a") -- Read all content
        infile:close()

        local outfile = io.open(exclude_conf_path, "wb") -- Open destination file in binary write mode
        if not outfile then
                print("Error: Could not open destination file for writing.")
                return
        end

        outfile:write(content) -- Write content to the destination file
        outfile:close()

        local handle = io.popen("git submodule foreach 'echo $sm_path/\\*' | grep -v Entering >> " .. exclude_conf_path .. " 2>/dev/null")
        handle:close()
end

generate_exclude_file()

sync {
    default.rsync,
    source = src,
    delete = false,
    target = tgt_host .. ":" .. src,
    exclude = {".git/",
            "compile_commands.json",
            "*.c_gen_events.*",
            "*d.tmp",
            "*/autogen/*",
            "app/python/*"},
    excludeFrom = exclude_conf_path,
    delay = 5,
}
