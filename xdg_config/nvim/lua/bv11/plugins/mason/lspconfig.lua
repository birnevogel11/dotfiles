local M = {}

M.setup = function()
  require("mason-lspconfig").setup({
    automatic_installation = true,
    ensure_installed = {
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
    },
  })

  require("mason-lspconfig").setup_handlers({
    function(server_name)
      vim.lsp.enable(server_name)
    end,
  })
end

return M
