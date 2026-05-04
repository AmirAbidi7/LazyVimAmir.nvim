return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },
  config = function()
    require("flutter-tools").setup({
      ui = {
        border = "rounded",
        notification_style = "nvim-notify",
      },
      decorations = {
        statusline = {
          app_version = true,
          device = true,
        },
      },
      debugger = {
        enabled = true,
        run_via_dap = true,
        exception_breakpoints = {},
      },
      flutter_path = "/home/amir/develop/flutter/bin/flutter", -- Direct path to Flutter
      flutter_lookup_cmd = nil, -- Not needed when flutter_path is set
      widget_guides = {
        enabled = true,
      },
      closing_tags = {
        highlight = "Comment",
        prefix = "// ",
        enabled = true,
      },
      dev_log = {
        enabled = true,
        open_cmd = "tabedit",
      },
      dev_tools = {
        autostart = false,
        auto_open_browser = false,
      },
      outline = {
        open_cmd = "30vnew",
        auto_open = false,
      },
      lsp = {
        color = {
          enabled = false, -- Disabled: dartls doesn't support textDocument/documentColor
          background = true,
          foreground = false,
          virtual_text = true,
          virtual_text_str = "■",
        },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          enableSnippets = true,
          updateImportsOnRename = true,
        },
      },
    })

    -- Keybindings for Flutter
    vim.keymap.set("n", "<leader>mf", "<cmd>Telescope flutter commands<cr>", { desc = "Flutter Commands" })
    vim.keymap.set("n", "<leader>md", "<cmd>FlutterDevices<cr>", { desc = "Flutter Devices (AVD)" })
    vim.keymap.set("n", "<leader>me", "<cmd>FlutterEmulators<cr>", { desc = "Flutter Emulators" })
    vim.keymap.set("n", "<leader>mr", "<cmd>FlutterRun<cr>", { desc = "Flutter Run" })
    vim.keymap.set("n", "<leader>mq", "<cmd>FlutterQuit<cr>", { desc = "Flutter Quit" })
    vim.keymap.set("n", "<leader>mR", "<cmd>FlutterRestart<cr>", { desc = "Flutter Restart" })
    vim.keymap.set("n", "<leader>mh", "<cmd>FlutterReload<cr>", { desc = "Flutter Hot Reload" })
    vim.keymap.set("n", "<leader>mo", "<cmd>FlutterOutlineToggle<cr>", { desc = "Flutter Outline" })
    vim.keymap.set("n", "<leader>ml", "<cmd>FlutterDevLog<cr>", { desc = "Flutter Logs" })
  end,
}
