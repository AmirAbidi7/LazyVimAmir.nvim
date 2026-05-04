return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000, -- Make sure to load this before all other plugins
    init = function()
      vim.cmd([[colorscheme catppuccin-frappe]])
    end,
    opts = {
      flavour = "frappe", -- latte, frappe, macchiato, mocha
      transparent_background = true,
      show_end_of_buffer = false, -- show the '~' characters after the end of buffers
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      integrations = {
        alpha = true,
        cmp = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = {
          enabled = true,
          scope_color = "lavender",
          colored_indent_levels = false,
        },
        lsp_trouble = true,
        mason = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        navic = {
          enabled = true,
          custom_bg = "NONE",
        },
        neotree = true,
        noice = true,
        notify = true,
        nvimtree = true,
        telescope = {
          enabled = true,
          style = "nvchad", -- or "classic"
        },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
        -- Add more integrations as needed
      },
      highlight_overrides = {
        frappe = function(colors)
          return {
            -- Make sidebars and floats transparent
            NormalFloat = { bg = "NONE" },
            FloatBorder = { bg = "NONE" },
            LazyNormal = { bg = colors.mantle },
            MasonNormal = { bg = colors.mantle },

            -- Sidebar backgrounds
            NeoTreeNormal = { bg = "NONE" },
            NeoTreeNormalNC = { bg = "NONE" },
            NvimTreeNormal = { bg = "NONE" },

            -- WhichKey
            WhichKeyFloat = { bg = "NONE" },

            -- Telescope
            TelescopeNormal = { bg = colors.mantle },
            TelescopeBorder = { bg = colors.mantle },

            -- Cmp
            Pmenu = { bg = colors.mantle },
            PmenuSel = { bg = colors.surface0 },

            -- Make windows more transparent
            Normal = { bg = "NONE" },
            SignColumn = { bg = "NONE" },
            MsgArea = { bg = "NONE" },
            LineNr = { bg = "NONE" },
            CursorLineNr = { bg = "NONE" },
          }
        end,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-frappe")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },
}
