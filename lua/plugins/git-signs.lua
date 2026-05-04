return {
  -- Disable gitsigns (the main culprit)
  { "lewis6991/gitsigns.nvim", enabled = false },

  -- Disable other git-related plugins that might cause errors
  { "tpope/vim-fugitive", enabled = false },
  { "sindrets/diffview.nvim", enabled = false },
  { "NeogitOrg/neogit", enabled = false },
  { "akinsho/git-conflict.nvim", enabled = false },
}
