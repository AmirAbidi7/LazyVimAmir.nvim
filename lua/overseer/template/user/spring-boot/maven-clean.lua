-- ~/.config/nvim/lua/overseer/template/user/maven.lua
return {
  name = "Maven: Clean",
  builder = function()
    local file = vim.fn.expand("%:p")
    local file_dir = vim.fn.fnamemodify(file, ":h")

    local function find_pom(start_dir)
      local dir = start_dir
      while dir ~= "/" do
        if vim.fn.filereadable(dir .. "/pom.xml") == 1 then
          return dir
        end
        dir = vim.fn.fnamemodify(dir, ":h")
      end
      return nil
    end

    local project_root = find_pom(file_dir)
    if not project_root then
      return { cmd = { "echo", "No pom.xml found" } }
    end

    return {
      cmd = { "./mvnw", "clean" },
      cwd = project_root,
    }
  end,
  condition = {
    filetype = { "java", "xml", "pom" },
    callback = function()
      return vim.fn.filereadable("pom.xml") == 1 or vim.fn.filereadable(vim.fn.getcwd() .. "/pom.xml") == 1
    end,
  },
  tags = { "maven", "clean" },
}
