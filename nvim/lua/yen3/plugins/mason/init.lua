local mason_setup = function()
  require("mason").setup({})

  require("mason-tool-installer").setup({
    ensure_installed = {
      "cspell",
      "hadolint",
      "markdownlint",
      "prettier",
      "shellcheck",
      "shfmt",
      "stylua",
      "yamlfmt",
      "yamllint",
    },
  })

  require("yen3.plugins.mason.lspconfig").setup()
  require("yen3.plugins.mason.conform").setup()
  require("yen3.plugins.mason.nvim_lint").setup()
  require("yen3.plugins.mason.dap").setup()
end

local pkg_config = {
  "williamboman/mason.nvim",
  branch = "main",
  event = "VeryLazy",
  dependencies = {
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    { "stevearc/conform.nvim" },
    { "mfussenegger/nvim-lint" },
    { "jayp0521/mason-null-ls.nvim" },
    { "jay-babu/mason-nvim-dap.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
  },
  config = mason_setup,
}

if os.getenv("NVIM_DAP_DEBUG_ENABLE") ~= nil then
  pkg_config.event = nil
end

return { pkg_config }
