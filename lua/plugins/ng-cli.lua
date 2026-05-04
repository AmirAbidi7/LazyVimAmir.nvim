return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values

    -- Function to find Angular project root from a file path
    local function find_angular_root(file_path)
      if not file_path or file_path == "" then
        file_path = vim.fn.getcwd()
      end

      local current_dir = vim.fn.fnamemodify(file_path, ":h")
      local dir = current_dir

      -- Search up the directory tree for Angular config files
      while dir ~= "" and dir ~= "/" do
        -- Check for Angular configuration files
        local angular_json = dir .. "/angular.json"
        local project_json = dir .. "/project.json"
        local package_json = dir .. "/package.json"

        if vim.fn.filereadable(angular_json) == 1 or vim.fn.filereadable(project_json) == 1 then
          return dir
        end

        -- Check if package.json has Angular dependencies
        if vim.fn.filereadable(package_json) == 1 then
          local package_content = vim.fn.readfile(package_json)
          local package_str = table.concat(package_content, "\n")
          if string.find(package_str, '"@angular/core"') or string.find(package_str, '"@angular/cli"') then
            return dir
          end
        end

        -- Go up one directory
        local parent_dir = vim.fn.fnamemodify(dir, ":h")
        if parent_dir == dir then
          break -- reached filesystem root
        end
        dir = parent_dir
      end

      return nil
    end

    -- Smart flag filtering - removes project-level configuration flags
    local function filter_flags(selected_command)
      if not selected_command.flags then
        return {}
      end

      local filtered_flags = {}
      local current_file = vim.fn.expand("%:p")
      local angular_root = find_angular_root(current_file)

      -- Check if project has angular.json to determine which flags to filter
      local has_angular_json = angular_root and vim.fn.filereadable(angular_root .. "/angular.json") == 1

      for _, flag_data in ipairs(selected_command.flags) do
        local include_flag = true

        -- Filter out project-level configuration flags when angular.json exists
        if has_angular_json then
          if
            flag_data.flag == "--style"
            or flag_data.flag == "--prefix"
            or flag_data.flag == "--change-detection"
            or flag_data.flag == "--display-block"
          then
            include_flag = false
          end
        end

        -- Always include these commonly used flags
        if
          flag_data.flag == "--flat"
          or flag_data.flag == "--skip-tests"
          or flag_data.flag == "--inline-style"
          or flag_data.flag == "--inline-template"
          or flag_data.flag == "--export"
          or flag_data.flag == "--skip-import"
          or flag_data.flag == "--routing"
          or flag_data.flag == "--route"
        then
          include_flag = true
        end

        if include_flag then
          table.insert(filtered_flags, flag_data)
        end
      end

      return filtered_flags
    end

    -- Function to execute Angular CLI command in the correct directory
    local function execute_angular_command(full_command)
      -- Smart Angular root detection
      local current_file = vim.fn.expand("%:p")
      local angular_root = find_angular_root(current_file)

      local cwd = angular_root or vim.fn.getcwd()

      if angular_root then
        print("✅ Using Angular project: " .. angular_root)
      else
        print("❌ No Angular project found for current file!")
        print("Current file: " .. current_file)
        print("Working directory: " .. vim.fn.getcwd())

        -- Ask user if they want to use current directory
        local use_current = vim.fn.input("Use current directory? (y/n): ")
        if use_current:lower() ~= "y" then
          return
        end
      end

      -- Use Snacks terminal with correct arguments
      local ok, snacks = pcall(require, "snacks")
      if ok and snacks.terminal then
        -- CORRECTED: Use the proper syntax for snacks.terminal
        snacks.terminal.open(full_command, {
          cwd = cwd,
          -- Add any other options snacks expects
        })
      else
        -- Fallback to simple terminal
        vim.cmd("split | terminal cd '" .. cwd .. "' && " .. full_command)
      end
    end
    -- Angular CLI commands database
    local angular_commands = {
      {
        name = "Generate Component",
        command = "generate component",
        input = true,
        input_prompt = "Component name:",
        flags = {
          { flag = "--change-detection", description = "Change detection strategy" },
          { flag = "--display-block", description = "Add :host display block" },
          { flag = "--export", description = "Export the component" },
          { flag = "--flat", description = "Create without folder" },
          { flag = "--inline-style", description = "Use inline styles" },
          { flag = "--inline-template", description = "Use inline template" },
          { flag = "--prefix", description = "Component prefix" },
          { flag = "--selector", description = "Component selector" },
          { flag = "--skip-import", description = "Skip module import" },
          { flag = "--skip-selector", description = "Skip selector generation" },
          { flag = "--skip-tests", description = "Skip test files" },
          { flag = "--style", description = "Style format (css/scss/less/sass)" },
          { flag = "--type", description = "Add type of component" },
        },
      },
      {
        name = "Generate Service",
        command = "generate service",
        input = true,
        input_prompt = "Service name:",
        flags = {
          { flag = "--flat", description = "Create without folder" },
          { flag = "--skip-tests", description = "Skip test files" },
        },
      },
      {
        name = "Generate Module",
        command = "generate module",
        input = true,
        input_prompt = "Module name:",
        flags = {
          { flag = "--flat", description = "Create without folder" },
          { flag = "--routing", description = "Generate routing module" },
          { flag = "--route", description = "Route path" },
        },
      },
      {
        name = "Generate Directive",
        command = "generate directive",
        input = true,
        input_prompt = "Directive name:",
        flags = {
          { flag = "--export", description = "Export the directive" },
          { flag = "--flat", description = "Create without folder" },
          { flag = "--prefix", description = "Directive prefix" },
          { flag = "--skip-import", description = "Skip module import" },
          { flag = "--skip-tests", description = "Skip test files" },
        },
      },
      {
        name = "Generate Pipe",
        command = "generate pipe",
        input = true,
        input_prompt = "Pipe name:",
        flags = {
          { flag = "--export", description = "Export the pipe" },
          { flag = "--flat", description = "Create without folder" },
          { flag = "--skip-import", description = "Skip module import" },
          { flag = "--skip-tests", description = "Skip test files" },
        },
      },
      {
        name = "Generate Guard",
        command = "generate guard",
        input = true,
        input_prompt = "Guard name:",
        flags = {
          { flag = "--flat", description = "Create without folder" },
          { flag = "--skip-tests", description = "Skip test files" },
          { flag = "--implements", description = "Specify which interfaces to implement" },
        },
      },
      {
        name = "Generate Interface",
        command = "generate interface",
        input = true,
        input_prompt = "Interface name:",
        flags = {
          { flag = "--prefix", description = "Interface prefix" },
        },
      },
      {
        name = "Generate Enum",
        command = "generate enum",
        input = true,
        input_prompt = "Enum name:",
        flags = {
          { flag = "--prefix", description = "Enum prefix" },
        },
      },
      {
        name = "Generate Class",
        command = "generate class",
        input = true,
        input_prompt = "Class name:",
        flags = {
          { flag = "--type", description = "Add type of class" },
        },
      },
      {
        name = "Add Package",
        command = "add",
        input = true,
        input_prompt = "Package name:",
        flags = {
          { flag = "--skip-confirmation", description = "Skip confirmation" },
          { flag = "--defaults", description = "Use defaults" },
        },
      },
      {
        name = "New Application",
        command = "new",
        input = true,
        input_prompt = "App name:",
        flags = {
          { flag = "--routing", description = "Generate routing module" },
          { flag = "--style", description = "Style format (css/scss/less/sass)" },
          { flag = "--skip-git", description = "Skip git initialization" },
          { flag = "--skip-install", description = "Skip package installation" },
          { flag = "--strict", description = "Enable strict mode" },
          { flag = "--package-manager", description = "Package manager (npm/yarn/pnpm)" },
        },
      },
      {
        name = "Serve Application",
        command = "serve",
        input = false,
        flags = {
          { flag = "--port", description = "Port to listen on" },
          { flag = "--host", description = "Host to listen on" },
          { flag = "--open", description = "Open browser automatically" },
          { flag = "--ssl", description = "Serve using HTTPS" },
          { flag = "--configuration", description = "Build configuration" },
        },
      },
      {
        name = "Build Application",
        command = "build",
        input = false,
        flags = {
          { flag = "--configuration", description = "Build configuration" },
          { flag = "--watch", description = "Watch for changes" },
          { flag = "--prod", description = "Production build" },
        },
      },
      {
        name = "Test Application",
        command = "test",
        input = false,
        flags = {
          { flag = "--watch", description = "Watch for changes" },
          { flag = "--code-coverage", description = "Generate code coverage" },
          { flag = "--browsers", description = "Browsers to run tests in" },
        },
      },
      {
        name = "Lint Application",
        command = "lint",
        input = false,
        flags = {
          { flag = "--fix", description = "Fix linting errors" },
          { flag = "--configuration", description = "Lint configuration" },
        },
      },
      {
        name = "Run Custom Target",
        command = "run",
        input = true,
        input_prompt = "Target name:",
        flags = {
          { flag = "--configuration", description = "Target configuration" },
        },
      },
    }

    -- Function to pick flags
    local function pick_flags(selected_command, name, callback)
      local filtered_flags = filter_flags(selected_command)

      if not filtered_flags or #filtered_flags == 0 then
        callback("")
        return
      end

      local flag_choices = {}
      for _, flag_data in ipairs(filtered_flags) do
        table.insert(flag_choices, {
          flag = flag_data.flag,
          description = flag_data.description,
          selected = false,
        })
      end

      -- Show a note about project defaults
      local current_file = vim.fn.expand("%:p")
      local angular_root = find_angular_root(current_file)
      local has_angular_json = angular_root and vim.fn.filereadable(angular_root .. "/angular.json") == 1

      local prompt_title = "Select Flags for " .. selected_command.name
      if has_angular_json then
        prompt_title = prompt_title .. " (project defaults used for style/prefix)"
      end

      pickers
        .new({}, {
          prompt_title = prompt_title,
          finder = finders.new_table({
            results = flag_choices,
            entry_maker = function(entry)
              return {
                value = entry,
                display = entry.flag .. " - " .. entry.description,
                ordinal = entry.flag,
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            local toggle_selection = function()
              local selection = action_state.get_selected_entry()
              if selection then
                selection.value.selected = not selection.value.selected
                -- Refresh the picker to show updated state
                require("telescope.actions.state").get_current_picker(prompt_bufnr):refresh(
                  finders.new_table({
                    results = flag_choices,
                    entry_maker = function(entry)
                      local prefix = entry.selected and "✓ " or "  "
                      return {
                        value = entry,
                        display = prefix .. entry.flag .. " - " .. entry.description,
                        ordinal = entry.flag,
                      }
                    end,
                  }),
                  { reset_prompt = true }
                )
              end
            end

            map("i", "<Space>", toggle_selection)
            map("n", "<Space>", toggle_selection)

            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selected_flags = {}
              for _, flag in ipairs(flag_choices) do
                if flag.selected then
                  table.insert(selected_flags, flag.flag)
                end
              end
              local flags_string = table.concat(selected_flags, " ")
              callback(flags_string)
            end)

            return true
          end,
        })
        :find()
    end

    -- Main Angular CLI picker
    function _G.angular_cli_picker()
      pickers
        .new({}, {
          prompt_title = "Angular CLI",
          finder = finders.new_table({
            results = angular_commands,
            entry_maker = function(entry)
              return {
                value = entry,
                display = entry.name,
                ordinal = entry.name,
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              if selection then
                local selected_command = selection.value

                if selected_command.input then
                  local name = vim.fn.input(selected_command.input_prompt .. " ")
                  if name and name ~= "" then
                    pick_flags(selected_command, name, function(flags)
                      local full_command = "ng " .. selected_command.command .. " " .. name .. " " .. flags
                      execute_angular_command(full_command)
                    end)
                  end
                else
                  pick_flags(selected_command, "", function(flags)
                    local full_command = "ng " .. selected_command.command .. " " .. flags
                    execute_angular_command(full_command)
                  end)
                end
              end
            end)
            return true
          end,
        })
        :find()
    end

    -- Quick commands without picker
    vim.api.nvim_create_user_command("NgGenerate", function(opts)
      if opts.args == "" then
        _G.angular_cli_picker()
      else
        execute_angular_command("ng generate " .. opts.args)
      end
    end, {
      nargs = "*",
      desc = "Angular: Generate component/service/etc",
    })

    vim.api.nvim_create_user_command("NgServe", function()
      execute_angular_command("ng serve")
    end, {
      desc = "Angular: Start dev server",
    })

    vim.api.nvim_create_user_command("NgBuild", function()
      execute_angular_command("ng build")
    end, {
      desc = "Angular: Build project",
    })

    vim.api.nvim_create_user_command("NgTest", function()
      execute_angular_command("ng test")
    end, {
      desc = "Angular: Run tests",
    })

    vim.api.nvim_create_user_command("NgAdd", function(opts)
      if opts.args == "" then
        local package = vim.fn.input("Package to add: ")
        if package and package ~= "" then
          execute_angular_command("ng add " .. package)
        end
      else
        execute_angular_command("ng add " .. opts.args)
      end
    end, {
      nargs = "*",
      desc = "Angular: Add package",
    })
  end,
}
