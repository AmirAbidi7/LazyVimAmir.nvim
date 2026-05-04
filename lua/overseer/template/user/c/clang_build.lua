return {
  name = "C build (clang)",
  builder = function()
    local file = vim.fn.expand("%:p")
    local file_dir = vim.fn.fnamemodify(file, ":h")
    local file_name = vim.fn.fnamemodify(file, ":t:r")

    return {
      cmd = { "clang", "-o", file_name, file },
      cwd = file_dir,
      components = {
        "on_output_quickfix",
      },
    }
  end,
  condition = {
    filetype = { "c" },
  },
}
