return {
  { "mason-org/mason.nvim",           enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          cmd = { "rust-analyzer" }, -- Use the system-installed rust-analyzer
        },
        pyright = {
          cmd = { "pyright-langserver", "--stdio" },
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
      },
    },
  }
}
