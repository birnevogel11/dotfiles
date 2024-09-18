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
  "clangd",
  "cssls",
  "docker_compose_language_service",
  "dockerls",
  "emmet_language_server",
  "esbonio", -- sphinx
  -- "gopls",
  "jinja_lsp",
  -- "hls",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "purescriptls",
  -- "pyright",
  -- "ruff",
  -- "rust_analyzer",
  "taplo",
  "texlab",
  "volar",
}

local custom_lsp_server_names = {
  "ansiblels",
  "bashls",
  "basedpyright",
  "clangd",
  "hls",
  "lua_ls",
  "purescriptls",
  "marksman",
  -- "pyright",
  -- "rust_analyzer",
}

M.setup = function()
  require("mason-lspconfig").setup({
    ensure_installed = installed_lsp_names,
  })

  require("mason-lspconfig").setup_handlers({
    function(server_name)
      if server_name ~= "rust_analyzer" then
        if table_contains(custom_lsp_server_names, server_name) then
          require("bv11.plugins.lsp.lsp_server")["lsp_server_" .. server_name]()
        end
      else
        require("lspconfig")[server_name].setup(require("bv11.plugins.lsp.base").lsp_create_config())
      end
    end,
  })
end

return M
