return {
  name = "C build & run",
  builder = function()
    local file = vim.fn.expand("%:p")
    local file_dir = vim.fn.fnamemodify(file, ":h")
    local file_name = vim.fn.fnamemodify(file, ":t:r")
    local executable = file_dir .. "/" .. file_name

    return {
      cmd = { "bash", "-c", "gcc -o " .. executable .. " " .. file .. " && " .. executable },
      cwd = file_dir,
    }
  end,
  condition = {
    filetype = { "c" },
  },
}
