return {
  name = "Spring Boot: Build",
  builder = function()
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
      vim.notify("Could not find Spring Boot project", vim.log.levels.ERROR)
      return { cmd = { "echo", "No project found" } }
    end

    local is_maven = vim.fn.filereadable(project_root .. "/pom.xml") == 1
    local cmd

    if is_maven then
      cmd = { "./mvnw", "clean", "package" }
      if vim.fn.filereadable(project_root .. "/mvnw") ~= 1 then
        cmd = { "mvn", "clean", "package" }
      end
    else
      cmd = { "./gradlew", "build" }
      if vim.fn.filereadable(project_root .. "/gradlew") ~= 1 then
        cmd = { "gradle", "build" }
      end
    end

    return {
      cmd = cmd,
      cwd = project_root,
    }
  end,
  condition = {
    filetype = { "java", "kotlin", "groovy", "xml", "gradle", "kts" },
  },
  tags = { "spring", "boot", "build" },
}
