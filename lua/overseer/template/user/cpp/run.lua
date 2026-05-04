return {
  name = "C++ run",
  builder = function()
    local file = vim.fn.expand("%:p")
    local file_dir = vim.fn.fnamemodify(file, ":h")
    local file_name = vim.fn.fnamemodify(file, ":t:r")
    local executable = file_dir .. "/" .. file_name

    return {
      cmd = { executable },
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
