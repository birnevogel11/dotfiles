local mason_lspconfig_setup = function()
  local ensure_installed = {
      "ansiblels",
      "basedpyright",
      "bashls",
      "docker_compose_language_service",
      "dockerls",
      "esbonio", -- sphinx
      "html",
      "jinja_lsp",
      "jsonls",
      "lua_ls",
      "marksman",
      -- "clangd",
      -- "cssls",
      -- "emmet_language_server",
      -- "gopls",
      -- "ltex",
      -- "purescriptls",
      -- "taplo",
      -- "texlab",
      -- "volar",
  }

  require("mason-lspconfig").setup({
    automatic_installation = true,
    ensure_installed = ensure_installed,
  })

  vim.lsp.enable(ensure_installed)
end

local mason_dap_setup = function()
  require("mason-nvim-dap").setup({
    ensure_installed = {
      "bash",
      -- required packages:
      --     sudo apt install -y gdb libc++-dev libc++abi-dev libstdc++-12-dev
      "codelldb", -- C/C++/Rust
      "cppdbg", -- C/C++
      -- "haskell",
    },
    automatic_installation = true,
    handlers = {
      function(config)
        require('mason-nvim-dap').default_setup(config)
      end
    }
  })
end

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

  mason_lspconfig_setup()
  mason_dap_setup()
end

return {
  {
    "williamboman/mason.nvim",
    branch = "main",
    event = "VeryLazy",
    dependencies = {
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { "jay-babu/mason-nvim-dap.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = mason_setup,
  }
}
