-- ~/.config/nvim/lua/plugins/astro-auto-config.lua
return {
  {
    "nvim-lua/plenary.nvim",
    config = function()
      local function create_astro_prettier_config(cwd)
        local config_path = cwd .. "/.prettierrc.mjs"
        local config_content = [[
/** @type {import("prettier").Config} */
export default {
  plugins: ["prettier-plugin-astro"],
  overrides: [
    {
      files: "*.astro",
      options: {
        parser: "astro",
      },
    },
  ],
};
]]

        -- Create the config file
        local file = io.open(config_path, "w")
        if file then
          file:write(config_content)
          file:close()
          vim.notify("✅ Created .prettierrc.mjs", vim.log.levels.INFO)

          -- Automatically install the plugin
          vim.notify("📦 Installing prettier and prettier-plugin-astro...", vim.log.levels.INFO)

          -- Detect package manager
          local has_pnpm = vim.fn.executable("pnpm") == 1
          local has_yarn = vim.fn.executable("yarn") == 1
          local has_npm = vim.fn.executable("npm") == 1

          -- Check for lock files to determine which package manager to use
          local has_pnpm_lock = vim.fn.filereadable(cwd .. "/pnpm-lock.yaml") == 1
          local has_yarn_lock = vim.fn.filereadable(cwd .. "/yarn.lock") == 1
          local has_package_json = vim.fn.filereadable(cwd .. "/package.json") == 1

          local cmd
          if has_pnpm and (has_pnpm_lock or not has_package_json) then
            cmd = "cd " .. cwd .. " && pnpm add --save-dev --save-exact prettier prettier-plugin-astro"
          elseif has_yarn and (has_yarn_lock or not has_package_json) then
            cmd = "cd " .. cwd .. " && yarn add -D prettier prettier-plugin-astro"
          elseif has_npm then
            cmd = "cd " .. cwd .. " && npm install --save-dev --save-exact prettier prettier-plugin-astro"
          else
            vim.notify("❌ No package manager found (npm/pnpm/yarn)", vim.log.levels.ERROR)
            return
          end

          -- Run installation in background
          vim.fn.jobstart(cmd, {
            on_exit = function(_, code)
              if code == 0 then
                vim.notify("✅ Successfully installed prettier and prettier-plugin-astro", vim.log.levels.INFO)

                -- Offer to restart prettierd if it's running
                if vim.fn.executable("prettierd") == 1 then
                  vim.fn.jobstart("prettierd stop", {
                    on_exit = function()
                      vim.notify("🔄 Restarted prettierd to pick up new config", vim.log.levels.INFO)
                    end,
                  })
                end
              else
                vim.notify("❌ Failed to install packages. Try manual install:", vim.log.levels.ERROR)
                vim.notify("  npm install --save-dev prettier prettier-plugin-astro", vim.log.levels.ERROR)
              end
            end,
          })
        end
      end

      local function check_and_setup_astro_config()
        -- Only run for astro files
        if vim.bo.filetype ~= "astro" then
          return
        end

        local cwd = vim.fn.getcwd()
        local config_paths = {
          cwd .. "/.prettierrc.mjs",
          cwd .. "/.prettierrc.js",
          cwd .. "/.prettierrc.cjs",
          cwd .. "/.prettierrc.json",
          cwd .. "/.prettierrc",
          cwd .. "/prettier.config.js",
          cwd .. "/prettier.config.cjs",
        }

        -- Check if any config exists
        local has_config = false
        for _, path in ipairs(config_paths) do
          if vim.fn.filereadable(path) == 1 then
            has_config = true
            break
          end
        end

        -- Also check if package.json has prettier config
        local package_path = cwd .. "/package.json"
        if not has_config and vim.fn.filereadable(package_path) == 1 then
          local ok, package = pcall(vim.fn.json_decode, vim.fn.readfile(package_path))
          if ok and package and package.prettier then
            has_config = true
          end
        end

        -- Check if plugin is installed
        local plugin_installed = false
        local plugin_paths = {
          cwd .. "/node_modules/prettier-plugin-astro",
          cwd .. "/node_modules/prettier-plugin-astro/package.json",
        }
        for _, path in ipairs(plugin_paths) do
          if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1 then
            plugin_installed = true
            break
          end
        end

        -- If no config OR no plugin, set up everything
        if not has_config or not plugin_installed then
          -- Small delay to avoid interrupting workflow
          vim.defer_fn(function()
            vim.notify("🔧 Setting up Prettier for Astro...", vim.log.levels.INFO)
            create_astro_prettier_config(cwd)
          end, 500)
        end
      end

      -- Auto-command for Astro files
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = { "*.astro" },
        callback = check_and_setup_astro_config,
      })

      -- Manual command if needed
      vim.api.nvim_create_user_command("AstroPrettierSetup", function()
        create_astro_prettier_config(vim.fn.getcwd())
      end, {})
    end,
  },
}
