return {
  "akinsho/toggleterm.nvim",
  lazy = true,
  config = function()
    require("toggleterm").setup({
      open_mapping = "<C-\\>",
      start_in_insert = true,
      direction = "float",
      -- shell = "nu",
    })

    -- Add your shell configuration
    -- vim.cmd([[let &shell = '"C:\Users\abidi\AppData\Local\Programs\nu\bin\nu.exe"']]) -- Adjust path to your Git Bash
    -- vim.cmd([[let &shellcmdflag = '-i']])

    -- Optional: Alternative shell setup using vim.o
    -- vim.o.shell = 'C:\\Program Files\\Git\\bin\\bash.exe'
    -- vim.o.shellcmdflag = '-s'
  end,
  keys = {
    {
      "<leader>Tc",
      function()
        require("toggleterm").new(0, LazyVim.root.get(), "float")
      end,
      desc = "Create new Term (float root_dir)",
    },

    {
      "<leader>Tf",
      function()
        local count = vim.v.count1
        require("toggleterm").toggle(count, 0, LazyVim.root.get(), "float")
      end,
      desc = "ToggleTerm (float root_dir)",
    },
    {
      "<leader>Th",
      function()
        local count = vim.v.count1
        require("toggleterm").toggle(count, 15, LazyVim.root.get(), "horizontal")
      end,
      desc = "ToggleTerm (horizontal root_dir)",
    },
    {
      "<leader>Tv",
      function()
        local count = vim.v.count1
        require("toggleterm").toggle(count, vim.o.columns * 0.4, LazyVim.root.get(), "vertical")
      end,
      desc = "ToggleTerm (vertical root_dir)",
    },
    {
      "<leader>Tn",
      "<cmd>ToggleTermSetName<cr>",
      desc = "Set term name",
    },
    {
      "<leader>Ts",
      "<cmd>TermSelect<cr>",
      desc = "Select term",
    },
    {
      "<leader>Tt",
      function()
        require("toggleterm").toggle(1, 100, LazyVim.root.get(), "tab")
      end,
      desc = "ToggleTerm (tab root_dir)",
    },
    {
      "<leader>TT",
      function()
        require("toggleterm").toggle(1, 100, vim.loop.cwd(), "tab")
      end,
      desc = "ToggleTerm (tab cwd_dir)",
    },
  },
}
-- print(vim.o.shell)
