-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- vim.keymap.set("n", "<leader>dj", "]d", { desc = "Next Diagnostic" })
-- vim.keymap.set("n", "<leader>dk", "[d", { desc = "Prev Diagnostic" })
vim.keymap.set("n", "<leader>z", ":.lua<CR>", { desc = "Execute this line of lua code" })
vim.keymap.set("v", "<leader>z", ":lua<CR>", { desc = "Execute this selection of lua code" })
vim.keymap.set("n", "<leader>ej", "]e", { desc = "Next Error" })
vim.keymap.set("n", "<leader>ek", "[e", { desc = "Prev Error" })
vim.keymap.set("n", "<leader>wj", "]w", { desc = "Next Warning" })
vim.keymap.set("n", "<leader>wk", "[w", { desc = "Prev Warning" })
vim.keymap.set("n", "<leader>en", require("snacks").explorer.open, { desc = "open file explorer" })
vim.keymap.del("n", "<leader>e")

-- Angular file navigation
local angular_functions = require("config.angular.functions")

-- Set the keymaps
vim.keymap.set(
  "n",
  "<leader>agn",
  angular_functions.angular_navigate,
  { desc = "Angular: Navigate to next related file" }
)
vim.keymap.set("n", "<leader>agc", angular_functions.angular_goto_component, { desc = "Angular: Go to component file" })
vim.keymap.set("n", "<leader>agt", angular_functions.angular_goto_template, { desc = "Angular: Go to template file" })
vim.keymap.set("n", "<leader>ags", angular_functions.angular_goto_style, { desc = "Angular: Go to style file" })
vim.keymap.set("n", "<leader>agx", angular_functions.angular_goto_test, { desc = "Angular: Go to test file" })

-- Angular cli functionality
vim.keymap.set("n", "<leader>agp", "<cmd>lua _G.angular_cli_picker()<cr>", { desc = "Angular: CLI Menu" })
vim.keymap.set("n", "<leader>agg", "<cmd>NgGenerate<cr>", { desc = "Angular: Generate" })
vim.keymap.set("n", "<leader>agS", "<cmd>NgServe<cr>", { desc = "Angular: Serve" })
vim.keymap.set("n", "<leader>agB", "<cmd>NgBuild<cr>", { desc = "Angular: Build" })
vim.keymap.set("n", "<leader>agT", "<cmd>NgTest<cr>", { desc = "Angular: Test" })
vim.keymap.set("n", "<leader>aga", "<cmd>NgAdd<cr>", { desc = "Angular: Add Package" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Dotnet keymaps
-- vim.keymap.set("n", "<leader>Dn", "<cmd>DotnetUI new_item<CR>", { desc = "Create a new Dotnet project" })
-- vim.keymap.set("n", "<leader>Dr", require("easy-dotnet").run, { desc = "Run dotnet project" })
-- vim.keymap.set("n", "<leader>Dpa", require("easy-dotnet").add_package, { desc = "Add NuGet Package" })
-- vim.keymap.set("n", "<leader>Dpr", require("easy-dotnet").remove_package, { desc = "Remove NuGet Package" })
vim.keymap.set(
  "n",
  "<leader>nma",
  require("easy-dotnet").ef_migrations_add,
  { desc = "Add Entity Framework Migration" }
)
vim.keymap.set(
  "n",
  "<leader>nml",
  require("easy-dotnet").ef_migrations_list,
  { desc = "List all Entity Frame Migration" }
)
vim.keymap.set(
  "n",
  "<leader>nme",
  require("easy-dotnet").ef_database_update,
  { desc = "Update database to current migration" }
)

vim.keymap.set(
  "n",
  "<leader>ee",
  "oif err != nil {<CR>return err<CR>}<Esc>k",
  { noremap = true, desc = "Insert error check" }
)
