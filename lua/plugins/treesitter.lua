return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "angular",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "html",
      "angular",
      "typescript",
      "javascript",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "html" },
    },
  },
}
