local M = {}

local table_contains = function(tbl, x)
  for _, v in pairs(tbl) do
    if v == x then
      return true
    end
  end
  return false
end

local installed_lsp_names = {
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
  -- "hls",
  -- "ltex",
  -- "purescriptls",
  -- "taplo",
  -- "texlab",
  -- "volar",
}

local custom_lsp_server_names = {
  "ansiblels",
  "bashls",
  "basedpyright",
  "clangd",
  "hls",
  "lua_ls",
  -- "purescriptls",
  -- "marksman",
  -- "pyright",
  -- "rust_analyzer",
}

M.setup = function()
  require("mason-lspconfig").setup({
    ensure_installed = installed_lsp_names,
  })

  require("mason-lspconfig").setup_handlers({
    function(server_name)
      if table_contains(custom_lsp_server_names, server_name) then
        require("bv11.plugins.lsp.lsp_server")["lsp_server_" .. server_name]()
      else
        require("lspconfig")[server_name].setup(require("bv11.plugins.lsp.lib").lsp_create_config())
      end
    end,
  })
end

return M
