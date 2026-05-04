return {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  dependencies = { "3rd/image.nvim" },
  build = ":UpdateRemotePlugins",
  init = function()
    -- Image provider setup
    vim.g.molten_image_provider = "image.nvim"
    
    -- Output window configuration
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_virt_lines_off_by_1 = false
    
    -- Keybindings for common Molten operations
    local molten_map = vim.keymap.set
    molten_map("n", "<leader>ni", ":MoltenInit<CR>", { noremap = true, silent = true, desc = "Molten: Initialize" })
    molten_map("n", "<leader>ne", ":MoltenEvaluateOperator<CR>", { noremap = true, silent = true, desc = "Molten: Evaluate motion" })
    molten_map("n", "<leader>nl", ":MoltenEvaluateLine<CR>", { noremap = true, silent = true, desc = "Molten: Evaluate line" })
    molten_map("v", "<leader>ne", ":MoltenEvaluateVisual<CR>", { noremap = true, silent = true, desc = "Molten: Evaluate selection" })
    molten_map("n", "<leader>no", ":MoltenReevaluateCell<CR>", { noremap = true, silent = true, desc = "Molten: Re-evaluate cell" })
    molten_map("n", "<leader>nd", ":MoltenDelete<CR>", { noremap = true, silent = true, desc = "Molten: Delete output" })
    molten_map("n", "<leader>nh", ":MoltenHideOutput<CR>", { noremap = true, silent = true, desc = "Molten: Hide output" })
    molten_map("n", "<leader>ns", ":MoltenShowOutput<CR>", { noremap = true, silent = true, desc = "Molten: Show output" })
  end,
  config = function()
    -- Command to create a new blank Jupyter notebook
    vim.api.nvim_create_user_command("MoltenNewNotebook", function(opts)
      local filename = opts.args or vim.fn.input("Notebook filename: ", "", "file")
      if filename == "" then
        vim.notify("No filename provided", vim.log.levels.WARN)
        return
      end
      
      -- Ensure .ipynb extension
      if not filename:match("%.ipynb$") then
        filename = filename .. ".ipynb"
      end
      
      -- Create notebook structure
      local notebook = {
        cells = {},
        metadata = {
          kernelspec = {
            display_name = "Python 3",
            language = "python",
            name = "python3"
          },
          language_info = {
            name = "python",
            version = "3.12.0"
          }
        },
        nbformat = 4,
        nbformat_minor = 4
      }
      
      -- Write notebook file
      local file = io.open(filename, "w")
      if not file then
        vim.notify("Failed to create file: " .. filename, vim.log.levels.ERROR)
        return
      end
      
      local json = vim.fn.json_encode(notebook)
      file:write(json)
      file:close()
      
      vim.notify("Created notebook: " .. filename, vim.log.levels.INFO)
      
      -- Open the notebook
      vim.cmd("edit " .. filename)
    end, { nargs = "?", complete = "file" })
  end,
}
