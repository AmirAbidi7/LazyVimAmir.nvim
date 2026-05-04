return {
  -- React Native support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- TypeScript/JavaScript LSP for React Native
        tsserver = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          settings = {
            typescript = {
              preferences = {
                importModuleSpecifierPreference = "relative",
              },
            },
          },
        },
      },
    },
  },

  -- React Native snippets and commands via toggleterm
  {
    "akinsho/toggleterm.nvim",
    optional = true,
    opts = function(_, opts)
      local Terminal = require("toggleterm.terminal").Terminal

      -- Metro bundler terminal
      local metro = Terminal:new({
        cmd = "npx react-native start",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "curved",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
      })

      -- Android runner
      local run_android = Terminal:new({
        cmd = "npx react-native run-android",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })

      -- iOS runner
      local run_ios = Terminal:new({
        cmd = "npx react-native run-ios",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })

      -- Expo runner (if using Expo)
      local expo_start = Terminal:new({
        cmd = "npx expo start",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })

      -- Create user commands
      vim.api.nvim_create_user_command("RNMetro", function()
        metro:toggle()
      end, { desc = "Start Metro Bundler" })

      vim.api.nvim_create_user_command("RNAndroid", function()
        run_android:toggle()
      end, { desc = "Run on Android" })

      vim.api.nvim_create_user_command("RNiOS", function()
        run_ios:toggle()
      end, { desc = "Run on iOS" })

      vim.api.nvim_create_user_command("ExpoStart", function()
        expo_start:toggle()
      end, { desc = "Start Expo" })

      -- Keybindings for React Native
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          -- Check if we're in a React Native project
          local package_json = vim.fn.findfile("package.json", ".;")
          if package_json ~= "" then
            local file = io.open(package_json, "r")
            if file then
              local content = file:read("*all")
              file:close()
              if content:match("react%-native") or content:match("expo") then
                vim.keymap.set("n", "<leader>mm", "<cmd>RNMetro<cr>", { desc = "Metro Bundler", buffer = buf })
                vim.keymap.set("n", "<leader>ma", "<cmd>RNAndroid<cr>", { desc = "Run Android", buffer = buf })
                vim.keymap.set("n", "<leader>mi", "<cmd>RNiOS<cr>", { desc = "Run iOS", buffer = buf })
                vim.keymap.set("n", "<leader>mx", "<cmd>ExpoStart<cr>", { desc = "Start Expo", buffer = buf })
                vim.keymap.set(
                  "n",
                  "<leader>mL",
                  "<cmd>!adb logcat<cr>",
                  { desc = "Android Logcat", buffer = buf }
                )
              end
            end
          end
        end,
      })

      return opts
    end,
  },

  -- React/JSX support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "javascript", "typescript", "tsx", "jsx" })
      end
    end,
  },
}
