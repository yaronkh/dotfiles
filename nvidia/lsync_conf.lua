settings {
   logfile    = "/tmp/lsyncd.log",
   statusFile = "/tmp/lsyncd.status",
   nodaemon   = true,
    statusInterval = 20,
    maxDelays = 0,
    maxProcesses = 1,
}

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local top = nil
local pipe = io.popen("pwd")
if pipe then
        top = trim(pipe:read("*a"))
        pipe:close()
end

local function getGitSubmodules(dir)
        local submodules = {}
        local command  = string.format("cd %s && git submodule --quiet foreach 'echo $sm_path'", dir)
        local handle = io.popen(command)
        if handle then
                for path in handle:lines() do
                        table.insert(submodules, top .. "/" .. path)
                end
                handle:close()
        end
        return submodules
end


local tgt_host = os.getenv("TGT_HOST")
if not tgt_host then
        error("Environment variable TGT_HOST is not set!")
end

local function ensure_target_dir()
        local cmd = "ssh " .. tgt_host .. " 'mkdir -p \"" .. top .. "\"'"
        local ret = os.execute(cmd)
        if ret == false then
                error("Failed to create target directory on host " .. tgt_host)
        end
end

ensure_target_dir()

-- Ensure we're at the top directory of the git repository
local function is_git_topdir(dir)
        local command = string.format(
                "git --work-tree=%s rev-parse --show-toplevel 2>/dev/null", dir)
        local handle = io.popen(command)
        local topdir = trim(handle:read("*l"))
        handle:close()
        if not topdir then
                print("Not in a git repository.")
                return false
        end

        if dir ~= topdir then
                print("Current directory (" ..
                dir .. ") is not the top directory of the git repository (" .. topdir .. ").")
                return false
        end
        return true
end

local function basename(path)
    -- Remove trailing slashes if any
    local cleanedPath = path:gsub("/+$", "")
    -- Extract the basename using string matching
    local basename = cleanedPath:match("([^/]+)$")
    return basename
end

-- Ensure target directory exists via SSH before syncing
local function generate_exclude_file(dir, exclude_conf_path)
        local source_file_path = dir .. "/.gitignore"
        local content = nil
        local content2

        local infile = io.open(source_file_path, "rb")         -- Open source file in binary read mode
        if infile then
                content = infile:read("*a")                    -- Read all content
                infile:close()
        end

        infile = io.open(dir .. "/excludes", "r")
        if infile then
                content2 = infile:read("*a")         -- Read all content
                infile:close()
        end

        local outfile = io.open(exclude_conf_path, "wb")         -- Open destination file in binary write mode
        if not outfile then
                print("Error: Could not open destination file for writing.")
                return
        end

        if content then
                outfile:write(content)         -- Write content to the destination file
        end

        if content2 then
                outfile:write("\n")
                outfile:write(content2)         -- Write content to the destination file
        end

        for _, d in ipairs(getGitSubmodules(dir)) do
                outfile:write(basename(d) .. "/*\n")
        end
        outfile:close()
end

local dirs = getGitSubmodules(top)
table.insert(dirs, 1, top)

for _, src in ipairs(dirs) do
        if not is_git_topdir(src) then
                error("lsyncd must be run from the top directory of the git repository.")
        end

        local exclude_conf_path = os.tmpname()
        print("Using exclude file: " .. exclude_conf_path)
        generate_exclude_file(src, exclude_conf_path)
        print("Syncing " .. src .. " with exclude file " .. exclude_conf_path)

        sync {
                default.rsync,
                source = src,
                delete = false,
                target = tgt_host .. ":" .. src,
                exclude = { ".git/",
                        "compile_commands.json",
                        "*.c_gen_events.*",
                        "*d.tmp",
                        "*/autogen/*",
                        "app/python/*" },
                excludeFrom = exclude_conf_path,
                delay = 5,
        }
end
