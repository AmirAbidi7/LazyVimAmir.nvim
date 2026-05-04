return {

  name = "Zig build run",
  builder = function()
    local current_file = vim.fn.expand("%:p")
    local current_dir = vim.fn.fnamemodify(current_file, ":h")

    -- Function to find main.zig by walking up the directory tree
    local function find_main_zig(start_dir)
      local dir = start_dir
      while dir ~= "/" do
        -- Check if main.zig exists in this directory
        if vim.fn.filereadable(dir .. "/main.zig") == 1 then
          return dir
        end
        -- Also check in src/ subdirectory (common Zig pattern)
        if vim.fn.filereadable(dir .. "/src/main.zig") == 1 then
          return dir .. "/src"
        end
        dir = vim.fn.fnamemodify(dir, ":h")
      end
      return nil
    end

    local main_zig_dir = find_main_zig(current_dir)

    if not main_zig_dir then
      vim.notify("Could not find main.zig in project", vim.log.levels.ERROR)
      return {}
    end
    print(main_zig_dir)

    -- If we found main.zig in src/, the project root is one level up
    local project_root = main_zig_dir
    if vim.fn.fnamemodify(main_zig_dir, ":t") == "src" then
      project_root = vim.fn.fnamemodify(main_zig_dir, ":h")
    end

    return {
      cmd = { "zig", "build", "run" },
      cwd = project_root,
      components = {
        { "on_output_quickfix", open = true },
        "default",
      },
    }
  end,
  condition = {
    filetype = { "zig" },
  },
}
