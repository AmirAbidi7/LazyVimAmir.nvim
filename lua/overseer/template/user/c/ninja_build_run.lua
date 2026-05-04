return {
  name = "C build & run (ninja)",
  builder = function()
    local file = vim.fn.expand("%:p")
    local file_dir = vim.fn.fnamemodify(file, ":h")
    local file_name = vim.fn.fnamemodify(file, ":t:r")

    local function find_build_ninja(start_dir)
      local dir = start_dir
      while dir ~= "/" do
        if vim.fn.filereadable(dir .. "/build.ninja") == 1 then
          return dir
        end
        dir = vim.fn.fnamemodify(dir, ":h")
      end
      return nil
    end

    local project_root = find_build_ninja(file_dir)
    if not project_root then
      vim.notify("Could not find build.ninja in project", vim.log.levels.ERROR)
      return {}
    end

    -- Look for executable in build directory (common pattern)
    local executable = project_root .. "/build/" .. file_name
    if vim.fn.executable(executable) ~= 1 then
      executable = project_root .. "/" .. file_name
    end

    return {
      cmd = { "sh", "-c", "ninja -C " .. project_root .. " && " .. executable },
      cwd = project_root,
      components = {
        "on_output_quickfix",
      },
    }
  end,
  condition = {
    filetype = { "c" },
  },
}
