return {
  name = "C++ build (g++)",
  builder = function()
    local file = vim.fn.expand("%:p")
    local file_dir = vim.fn.fnamemodify(file, ":h")
    local file_name = vim.fn.fnamemodify(file, ":t:r")

    return {
      cmd = { "g++", "-o", file_name, file },
      cwd = file_dir,
      components = {
        "on_output_quickfix",
      },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
