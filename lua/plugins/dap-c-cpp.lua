return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mason-org/mason.nvim",
      optional = true,
      opts = { ensure_installed = { "codelldb" } },
    },
    opts = function()
      local dap = require("dap")
      if not dap.adapters["codelldb"] then
        dap.adapters["codelldb"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "codelldb",
            args = { "--port", "${port}" },
          },
        }
      end

      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file (with debug build)",
            program = function()
              -- Auto-compile with debug symbols
              local cwd = vim.fn.getcwd()
              print("Building with debug symbols...")
              local result = vim.fn.system("cd " .. cwd .. " && gcc -g -o main main.c 2>&1")
              if vim.v.shell_error ~= 0 then
                print("Compilation failed:\n" .. result)
                return nil
              end
              print("Build successful!")
              return cwd .. "/main"
            end,
            cwd = "${workspaceFolder}",
          },
          {
            type = "codelldb",
            request = "attach",
            name = "Attach to process",
            pid = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    optional = true,
    opts = {
      render = {
        indent = 1,
        max_type_length = nil,
        max_value_lines = 100,
      },
      expand_lines = true,
      controls = {
        enabled = true,
        element = "repl",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.33 },
            { id = "breakpoints", size = 0.17 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 1 },
          },
          size = 10,
          position = "bottom",
        },
      },
    },
  },
}
