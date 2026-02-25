return {
  name = "Spring Boot: Devtools Restart",
  builder = function()
    -- This triggers a restart if you have spring-boot-devtools configured
    -- Touch the trigger file
    local file = vim.fn.expand("%:p")
    local file_dir = vim.fn.fnamemodify(file, ":h")

    local function find_project_root(start_dir)
      local dir = start_dir
      while dir ~= "/" do
        if
          vim.fn.filereadable(dir .. "/pom.xml") == 1
          or vim.fn.filereadable(dir .. "/build.gradle") == 1
          or vim.fn.filereadable(dir .. "/build.gradle.kts") == 1
        then
          return dir
        end
        dir = vim.fn.fnamemodify(dir, ":h")
      end
      return nil
    end

    local project_root = find_project_root(file_dir)
    if not project_root then
      return { cmd = { "echo", "No Spring project" } }
    end

    -- Touch a file to trigger devtools restart
    return {
      cmd = { "touch", project_root .. "/target/trigger.txt" },
      cwd = project_root,
      components = {
        "default",
      },
    }
  end,
  condition = {
    filetype = { "java", "kotlin", "groovy", "xml" },
  },
  tags = { "spring", "devtools", "restart" },
}
