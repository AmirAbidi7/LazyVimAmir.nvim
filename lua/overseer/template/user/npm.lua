-- Override npm template to skip in Deno projects and use builtin in npm projects
local files = require("overseer.files")

---@type table<string, string[]>
local mgr_lockfiles = {
  npm = { "package-lock.json" },
  pnpm = { "pnpm-lock.yaml" },
  yarn = { "yarn.lock" },
  bun = { "bun.lockb", "bun.lock" },
}

---@param opts overseer.SearchParams
local function get_candidate_package_files(opts)
  local matches = vim.fs.find("package.json", {
    upward = true,
    type = "file",
    path = opts.dir,
    stop = vim.fn.getcwd() .. "/..",
    limit = math.huge,
  })
  if #matches > 0 then
    return matches
  end
  return vim.fs.find("package.json", {
    upward = true,
    type = "file",
    path = vim.fn.getcwd(),
  })
end

---@param package_dir string
---@return string|nil
local function detect_package_manager(package_dir)
  for mgr, lockfiles in pairs(mgr_lockfiles) do
    for _, lockfile in ipairs(lockfiles) do
      if vim.uv.fs_stat(vim.fs.joinpath(package_dir, lockfile)) then
        return mgr
      end
    end
  end
  return nil
end

---@param candidate_packages string[]
---@return { package: string, manager: string }|nil
local function get_package_and_manager(candidate_packages)
  for _, package_file in ipairs(candidate_packages) do
    local data = files.load_json_file(package_file)
    if data.scripts or data.workspaces then
      local package_dir = vim.fs.dirname(package_file)
      local manager = detect_package_manager(package_dir)
      if manager then
        return { package = package_file, manager = manager }
      end
    end
  end

  for _, package_file in ipairs(candidate_packages) do
    local data = files.load_json_file(package_file)
    if data.scripts or data.workspaces then
      return { package = package_file, manager = "npm" }
    end
  end

  return nil
end

return {
  generator = function(opts)
    -- Check if this is a Deno project by searching upward for deno.lock
    local search_dir = opts.dir or vim.fn.getcwd()
    
    local function find_deno_lock(start_dir)
      local dir = start_dir
      while dir ~= "/" do
        if vim.fn.filereadable(dir .. "/deno.lock") == 1 then
          return dir
        end
        dir = vim.fn.fnamemodify(dir, ":h")
      end
      return nil
    end
    
    if find_deno_lock(search_dir) then
      -- Skip npm template in Deno projects
      return "Deno project detected (deno.lock found) - npm tasks disabled"
    end
    
    -- Otherwise, generate npm tasks (copy of builtin npm logic)
    local candidate_packages = get_candidate_package_files(opts)
    local result = get_package_and_manager(candidate_packages)
    if not result then
      return "No package.json file found"
    end
    local package = result.package
    local bin = result.manager
    if vim.fn.executable(bin) == 0 then
      return string.format("Could not find command '%s'", bin)
    end

    local data = files.load_json_file(package)
    local ret = {}
    local cwd = vim.fs.dirname(package)
    if data.scripts then
      for k in pairs(data.scripts) do
        table.insert(ret, {
          name = string.format("%s %s (%s)", bin, k, data.name),
          builder = function()
            return {
              cmd = { bin, "run", k },
              cwd = cwd,
            }
          end,
        })
      end
    end

    -- Load tasks from workspaces
    if data.workspaces then
      for _, workspace in ipairs(data.workspaces) do
        local workspace_path = vim.fs.joinpath(cwd, workspace)
        local workspace_package_file = vim.fs.joinpath(workspace_path, "package.json")
        local workspace_data = files.load_json_file(workspace_package_file)
        if workspace_data and workspace_data.scripts then
          for k in pairs(workspace_data.scripts) do
            table.insert(ret, {
              name = string.format("%s[%s] %s", bin, workspace, k),
              builder = function()
                return {
                  cmd = { bin, "run", k },
                  cwd = workspace_path,
                }
              end,
            })
          end
        end
      end
    end

    table.insert(ret, {
      name = bin .. " install",
      builder = function()
        return {
          cmd = { bin, "install" },
          cwd = cwd,
        }
      end,
    })
    return ret
  end,
}
