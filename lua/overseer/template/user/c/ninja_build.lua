return {
  name = "C build (ninja)",
  builder = function()
    local file = vim.fn.expand("%:p")
    local file_dir = vim.fn.fnamemodify(file, ":h")

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

    return {
      cmd = { "ninja", "-C", project_root },
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
