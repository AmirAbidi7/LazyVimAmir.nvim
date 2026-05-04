-- Mobile Development Unified Configuration
return {
  {
    "akinsho/toggleterm.nvim",
    lazy = false,
    config = function()
      require("toggleterm").setup()

      local Terminal = require("toggleterm.terminal").Terminal

      -- AVD Manager - Universal for all frameworks
      local avd_manager = Terminal:new({
        cmd = "avdmanager list avd",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "curved",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(
            term.bufnr,
            "n",
            "q",
            "<cmd>close<CR>",
            { noremap = true, silent = true, desc = "Close AVD Manager" }
          )
        end,
      })

      -- ADB devices
      local adb_devices = Terminal:new({
        cmd = "adb devices -l",
        hidden = true,
        direction = "float",
        close_on_exit = false,
      })

      -- Emulator launcher (interactive)
      local launch_emulator = Terminal:new({
        cmd = 'emulator -list-avds | fzf | xargs -I {} emulator -avd {}',
        hidden = true,
        direction = "float",
        close_on_exit = false,
      })

      -- Create unified mobile dev commands
      vim.api.nvim_create_user_command("MobileDevices", function()
        adb_devices:toggle()
      end, { desc = "List Android Devices (ADB)" })

      vim.api.nvim_create_user_command("MobileAVD", function()
        avd_manager:toggle()
      end, { desc = "Android Virtual Device Manager" })

      vim.api.nvim_create_user_command("MobileLaunchEmulator", function()
        launch_emulator:toggle()
      end, { desc = "Launch Android Emulator" })

      vim.api.nvim_create_user_command("MobileLogcat", function()
        vim.cmd("!adb logcat")
      end, { desc = "Android Logcat" })

      -- Global keybindings (not filetype-specific)
      vim.keymap.set("n", "<leader>md", "<cmd>MobileDevices<cr>", { desc = "Devices (ADB)" })
      vim.keymap.set("n", "<leader>mA", "<cmd>MobileAVD<cr>", { desc = "AVD Manager" })
      vim.keymap.set("n", "<leader>mL", "<cmd>MobileLogcat<cr>", { desc = "Android Logcat" })
      vim.keymap.set("n", "<leader>mE", "<cmd>MobileLaunchEmulator<cr>", { desc = "Launch Emulator" })
    end,
  },

  -- Global mobile dev keybindings (works across all frameworks)
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>m", group = "mobile", icon = "" },
      },
    },
  },
}
