return {
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = function()
      -- Get the default opts
      local opts = {
        modes = { insert = true, command = true, terminal = false },
        -- skip autopair when next character is one of these
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        -- skip autopair when the cursor is inside these treesitter nodes
        skip_ts = { "string" },
        -- skip autopair when next character is closing pair
        -- and there are more closing pairs than opening pairs
        skip_unbalanced = true,
        -- better deal with markdown code blocks
        markdown = true,
      }

      -- Add custom mappings for pipes
      opts.mappings = {
        -- Your existing mappings will be added by LazyVim automatically
        -- Add the pipe mapping
        ["|"] = { action = "open", pair = "||", neigh_pattern = "[^\\|]", register = { cr = false } },
      }

      return opts
    end,
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },
}
