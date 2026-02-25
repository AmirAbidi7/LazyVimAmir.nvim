return {
  name = "Zig build",
  builder = function()
    local file = vim.fn.expand("%:p")
    local file_dir = vim.fn.fnamemodify(file, ":h")

    local function find_build(start_dir)
      local dir = start_dir
      while dir ~= "/" do
        if vim.fn.filereadable(dir .. "/build.zig") == 1 then
          print("FOUND Build.zig at " .. dir)
          return dir
        end
        dir = vim.fn.fnamemodify(dir, ":h")
      end
      return nil
    end

    local main_zig_dir = find_build(file_dir)
    if not main_zig_dir then
      vim.notify("Could not find vim project", vim.log.levels.ERROR)
      return {}
    end
    print(main_zig_dir)

    return {
      cmd = { "zig", "build" },
      cwd = main_zig_dir,
    }
  end,
  condition = {
    filetype = { "zig" },
  },
}
