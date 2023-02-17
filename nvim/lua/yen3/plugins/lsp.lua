return {
  { "neovim/nvim-lspconfig",
    event = "BufRead",
    dependencies = {
      { "nvim-lua/lsp-status.nvim" },
      { "MrcJkb/haskell-tools.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("yen3.lsp").lsp_config_setup()
      require("yen3.lsp").lsp_status()
    end,
  },
  { "j-hui/fidget.nvim", ft = {"lua", "go", "rust"},
    config = function()
      require("fidget").setup({
        text = {
          spinner = "dots",
        },
        align = {
          bottom = true,
        },
        window = {
          relative = "editor",
        },
      })
    end
  },
}
