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
  "bashls",
  "clangd",
  "dockerls",
  "esbonio", -- sphinx
  "gopls",
  "html",
  "hls",
  "jsonls",
  "marksman",
  "purescriptls",
  -- "pyright",
  "ruff_lsp",
  "rust_analyzer",
  "lua_ls",
  "taplo",
  "texlab",
  "tsserver",
}

local custom_lsp_server_names = {
  "pyright",
  "ruff_lsp",
  "rust_analyzer",
  "purescriptls",
  "ansiblels",
  "lua_ls",
  "clangd",
  "hls",
}

M.setup = function()
  require("mason-lspconfig").setup({
    ensure_installed = installed_lsp_names,
  })

  require("mason-lspconfig").setup_handlers({
    function(server_name)
      if table_contains(custom_lsp_server_names, server_name) then
        require("yen3.plugins.lsp.lsp_server")["lsp_server_" .. server_name]()
      else
        require("lspconfig")[server_name].setup(require("yen3.plugins.lsp.base").lsp_create_config())
      end
    end,
  })
end

return M
