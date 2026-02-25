return {
  name = "Zig build test",
  builder = function()
    local file = vim.fn.expand("%:p")
    local file_dir = vim.fn.fnamemodify(file, ":h")

    local function find_build_file(start_dir)
      local dir = start_dir
      while dir ~= "/" do
        if vim.fn.filereadable(dir .. "/build.zig") == 1 then
          return dir
        end
        dir = vim.fn.fnamemodify(dir, ":h")
      end
      return nil
    end

    local project_dir = find_build_file(file_dir)
    if not project_dir then
      vim.notify("Could not find build.zig", vim.log.levels.ERROR)
      return {}
    end
    print(project_dir)

    return {
      cmd = { "zig", "build", "test" },
      cwd = project_dir,
    }
  end,
  condition = {
    filetype = { "zig" },
  },
}
