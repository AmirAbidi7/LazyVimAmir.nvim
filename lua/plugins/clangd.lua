return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            compilationDatabasePath = "build",
            fallbackFlags = {
              "-I",
              "C:/Program Files (x86)/Microsoft SDKs/MPI/Include",
              "-D_AMD64_",
              "--target=x86_64-w64-windows-gnu",
            },
          },
        },
      },
    },
  },
}
