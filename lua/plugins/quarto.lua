return {
  "quarto-dev/quarto-nvim",
  dependencies = {
    "jmbuhr/otter.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "quarto", "markdown" },
  opts = {
    lspFeatures = {
      languages = { "python", "r", "bash" },
      chunks = "all",
      diagnostics = {
        enabled = true,
        triggers = { "BufWritePost" },
      },
      completion = {
        enabled = true,
      },
    },
    keymap = {
      hover = "K",
      definition = "gd",
      rename = "<leader>rn",
      references = "gr",
    },
    codeRunner = {
      enabled = true,
      default_method = "molten",
    },
  },
  config = function(_, opts)
    require("quarto").setup(opts)
    
    local runner = require("quarto.runner")
    
    -- Keybindings for running cells with Molten
    vim.keymap.set("n", "<leader>rc", runner.run_cell, { 
      desc = "Run cell", 
      silent = true,
      buffer = true 
    })
    vim.keymap.set("n", "<leader>ra", runner.run_above, { 
      desc = "Run cell and above", 
      silent = true,
      buffer = true 
    })
    vim.keymap.set("n", "<leader>rA", runner.run_all, { 
      desc = "Run all cells", 
      silent = true,
      buffer = true 
    })
    vim.keymap.set("n", "<leader>rl", runner.run_line, { 
      desc = "Run line", 
      silent = true,
      buffer = true 
    })
    vim.keymap.set("v", "<leader>r", runner.run_range, { 
      desc = "Run visual range", 
      silent = true,
      buffer = true 
    })
  end,
}
