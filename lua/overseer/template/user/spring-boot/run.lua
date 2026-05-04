return {
  name = "Spring Boot: Run",
  builder = function()
    -- Find the project root (where pom.xml or build.gradle is)
    local file = vim.fn.expand("%:p")
    local file_dir = vim.fn.fnamemodify(file, ":h")

    local function find_project_root(start_dir)
      local dir = start_dir
      while dir ~= "/" do
        -- Check for Maven or Gradle project markers
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
      vim.notify("Could not find Spring Boot project (pom.xml or build.gradle)", vim.log.levels.ERROR)
      return { cmd = { "echo", "No Spring Boot project found" } }
    end

    -- Check if it's Maven or Gradle
    local is_maven = vim.fn.filereadable(project_root .. "/pom.xml") == 1
    local cmd

    if is_maven then
      cmd = { "./mvnw", "spring-boot:run" }
      -- Fallback to mvn if mvnw doesn't exist
      if vim.fn.filereadable(project_root .. "/mvnw") ~= 1 then
        cmd = { "mvn", "spring-boot:run" }
      end
    else
      cmd = { "./gradlew", "bootRun" }
      -- Fallback to gradle if gradlew doesn't exist
      if vim.fn.filereadable(project_root .. "/gradlew") ~= 1 then
        cmd = { "gradle", "bootRun" }
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
  tags = { "spring", "boot", "run" },
}
