-- Deno task generator
-- Dynamically generates deno tasks if deno.lock is detected

return {
  generator = function(opts)
    local search_dir = opts.dir or vim.fn.getcwd()
    
    -- Search upward for deno.lock to detect if this is a Deno project
    local function find_deno_lock(start_dir)
      local dir = start_dir
      while dir ~= "/" do
        if vim.fn.filereadable(dir .. "/deno.lock") == 1 then
          return dir
        end
        dir = vim.fn.fnamemodify(dir, ":h")
      end
      return nil
    end

    local project_root = find_deno_lock(search_dir)
    if not project_root then
      return "deno.lock not found - skipping deno tasks"
    end

    local tasks = {}

    -- Deno: Run
    table.insert(tasks, {
      name = "Deno: Run",
      builder = function()
        local file = vim.fn.expand("%:p")
        return {
          cmd = { "deno", "run", file },
          cwd = project_root,
          components = {
            "default",
          },
        }
      end,
      tags = { "deno", "run" },
    })

    -- Deno: Test
    table.insert(tasks, {
      name = "Deno: Test",
      builder = function()
        return {
          cmd = { "deno", "test" },
          cwd = project_root,
          components = {
            "default",
          },
        }
      end,
      tags = { "deno", "test" },
    })

    -- Deno: Format
    table.insert(tasks, {
      name = "Deno: Format",
      builder = function()
        return {
          cmd = { "deno", "fmt" },
          cwd = project_root,
          components = {
            "default",
          },
        }
      end,
      tags = { "deno", "format" },
    })

    -- Deno: Lint
    table.insert(tasks, {
      name = "Deno: Lint",
      builder = function()
        return {
          cmd = { "deno", "lint" },
          cwd = project_root,
          components = {
            "default",
          },
        }
      end,
      tags = { "deno", "lint" },
    })

    -- Deno: Check
    table.insert(tasks, {
      name = "Deno: Check",
      builder = function()
        local file = vim.fn.expand("%:p")
        return {
          cmd = { "deno", "check", file },
          cwd = project_root,
          components = {
            "default",
          },
        }
      end,
      tags = { "deno", "check" },
    })

    -- Deno: Task Dev
    table.insert(tasks, {
      name = "Deno: Task Dev",
      builder = function()
        return {
          cmd = { "deno", "task", "dev" },
          cwd = project_root,
          components = {
            "default",
          },
        }
      end,
      tags = { "deno", "task", "dev" },
    })

    -- Deno: Task (dynamic selection)
    table.insert(tasks, {
      name = "Deno: Task",
      builder = function()
        local config_path = project_root .. "/deno.json"
        if vim.fn.filereadable(config_path) ~= 1 then
          config_path = project_root .. "/deno.jsonc"
        end

        if vim.fn.filereadable(config_path) ~= 1 then
          return {}
        end

        local config_content = vim.fn.readfile(config_path)
        local config_str = table.concat(config_content, "\n")

        local tasks_list = {}
        for task_name in config_str:gmatch('"([^"]+)"%s*:%s*"[^"]*"') do
          table.insert(tasks_list, task_name)
        end

        if #tasks_list == 0 then
          return {}
        end

        local task_choice = vim.fn.inputlist(tasks_list)
        if task_choice < 1 or task_choice > #tasks_list then
          return {}
        end

        local selected_task = tasks_list[task_choice]

        return {
          cmd = { "deno", "task", selected_task },
          cwd = project_root,
          components = {
            "default",
          },
        }
      end,
      tags = { "deno", "task" },
    })

    return tasks
  end,
}
