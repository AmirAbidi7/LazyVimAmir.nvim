return {
  {
    "stevearc/overseer.nvim",
    opts = {
      -- Disable the built-in npm template to avoid duplicates with our custom one
      disable_template_modules = {
        "overseer.template.npm",
      },
      -- Load both builtin (minus npm) and user templates
      templates = {
        "builtin",
        "user",
      },
    },
  },
}
