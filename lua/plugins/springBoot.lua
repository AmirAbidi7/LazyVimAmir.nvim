return {
  {
    "jkeresman01/spring-initializr.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
    },
    lazy = false,
    -- ft = { "java" },
    config = function()
      require("spring-initializr").setup()
    end,
  },
  {
    "elmcgill/springboot-nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    lazy = true,
    ft = { "java" },
    config = function()
      local springboot_nvim = require("springboot-nvim")

      -- Set up keymaps
      -- vim.keymap.set("n", "<leader>Jr", springboot_nvim.boot_run, { desc = "Spring Boot Run Project" })
      -- vim.keymap.set("n", "<leader>Jc", springboot_nvim.generate_class, { desc = "Java Create Class" })
      -- vim.keymap.set("n", "<leader>Ji", springboot_nvim.generate_interface, { desc = "Java Create Interface" })
      -- vim.keymap.set("n", "<leader>Je", springboot_nvim.generate_enum, { desc = "Java Create Enum" })

      -- Optional: Add a keymap to manually view compilation errors when you want them
      vim.keymap.set("n", "<leader>jv", function()
        vim.cmd("copen") -- Open quickfix window to see errors
      end, { desc = "Show Compilation Errors" })

      -- Initialize the plugin with custom on_compile_result callback
      springboot_nvim.setup({
        -- Custom callback that does NOT open the quickfix window automatically
        on_compile_result = function(results)
          -- Results are the compile errors/warnings
          -- You can:
          -- 1. Do nothing (no popup window!)
          -- 2. Store them somewhere if you want
          -- 3. Show a subtle notification with error count

          -- Option 1: Do absolutely nothing (no popup!)
          -- Just return without opening quickfix

          -- Option 2: Show error count in a subtle message (uncomment if desired)
          -- if results and #results > 0 then
          --   vim.notify(string.format("Compilation: %d issues found", #results), vim.log.levels.INFO)
          -- end

          -- Option 3: Still store in quickfix but don't open window (uncomment if desired)
          -- if results and #results > 0 then
          --   vim.fn.setqflist({}, ' ', {
          --     title = 'Compile Errors',
          --     items = results,
          --   })
          -- end
        end,
      })
    end,
  },
  {
    "alessio-vivaldelli/java-creator-nvim",
    config = function()
      require("java-creator-nvim").setup({
        options = {
          java_version = 17,
          auto_open = true,
          use_notify = true,
          custom_src_path = "backend/src/main/java",
          src_patterns = { "src/main/java", "src/test/java", "src" },
          project_markers = {
            "pom.xml",
            "build.gradle",
            "build.gradle.kts",
            "settings.gradle",
            "settings.gradle.kts",
            ".project",
          },
          notification_timeout = 3000,
        },
        keymaps = {
          java_new = "<leader>jn",
          java_class = "<leader>jc",
          java_interface = "<leader>ji",
          java_enum = "<leader>je",
          java_record = "<leader>jr",
        },
        default_imports = {
          record = { "java.util.*" }, -- Import di default per i record
        },
      })

      vim.keymap.set("i", "<C-space>", 'pumvisible() ? "\\<C-n>" : "\\<C-x>\\<C-u>"', {
        expr = true,
        desc = "",
      })
    end,
    ft = "java",
    event = "VeryLazy",
    dependencies = {
      { "rcarriga/nvim-notify", optional = true },
    },
  },
}
