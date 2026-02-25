-- ~/.config/nvim/lua/overseer/template/user/maven_update.lua
return {
  name = "Maven: Update dependencies",
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
      cmd = { "./mvnw", "dependency:resolve" },
      cwd = project_root,
    }
  end,
  condition = {
    filetype = { "java", "xml", "pom" },
  },
  tags = { "maven", "dependencies", "update" },
}
