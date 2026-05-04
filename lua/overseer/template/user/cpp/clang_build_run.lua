return {
  name = "C++ build & run (clang)",
  builder = function()
    local file = vim.fn.expand("%:p")
    local file_dir = vim.fn.fnamemodify(file, ":h")
    local file_name = vim.fn.fnamemodify(file, ":t:r")
    local executable = file_dir .. "/" .. file_name

    return {
      cmd = { "sh", "-c", "clang++ -o " .. file_name .. " " .. file .. " && " .. executable },
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
