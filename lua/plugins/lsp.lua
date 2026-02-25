-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
              },
              diagnostics = {
                globals = { "vim" }, -- Add vim as a global
              },
              workspace = {
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        -- Add emmet_language_server configuration
        emmet_language_server = {
          filetypes = {
            "html",
            "css",
            "sass",
            "scss",
            "less",
            "javascript",
            "typescript",
            "markdown",
            -- "typescriptreact", -- Removed
            -- "javascriptreact", -- Removed
          },
          -- Emmet language server specific settings
          init_options = {
            preferences = {
              -- Common Emmet preferences
              ["bem.enabled"] = true,
              ["css.propertyEnd"] = ";",
              ["css.valueSeparator"] = ": ",
              ["filter.commentAfter"] = "<!-- /<%= attr('class', '#') %> -->",
              ["filter.commentTrigger"] = { "id", "class" }, -- Fixed: Use {} not []
              ["output.attributeQuotes"] = "double",
              ["output.format"] = true,
              ["output.selfClosingStyle"] = "html",
              ["sass.propertyEnd"] = ";",
              ["sass.valueSeparator"] = ": ",
              ["stylus.valueSeparator"] = " ",
            },
            showAbbreviationPreview = false,
            showExpandedAbbreviation = "always",
            showSuggestionsAsSnippets = true,
            syntaxProfiles = {
              html = "html",
              css = "css",
              javascript = "jsx",
              typescript = "tsx",
            },
          },
        },
      },
    },
  },
}
