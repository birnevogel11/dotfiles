local nvim_lsp = require("lspconfig")
local nvim_status = require("lsp-status")
local keymap_n = require("yen3.lib.keymap").keymap_n

local M = {}

M.custom_update_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("keep", capabilities, nvim_status.capabilities)
  return require("cmp_nvim_lsp").default_capabilities(capabilities)
end

local lsp_attach_keymap = function(bufnr)
  local nmap = function(lhs, func, desc)
    keymap_n(lhs, func, desc, bufnr)
  end

  nmap("K", vim.lsp.buf.hover, "LSP: hover documentation")
  nmap("<leader>dk", vim.lsp.buf.signature_help, "LSP: signature help")
  nmap("<leader>dr", vim.lsp.buf.rename, "LSP: rename")
  nmap("<leader>df", vim.diagnostic.open_float, "LSP: show line diagnostics")
  nmap("<leader>da", vim.lsp.buf.code_action, "LSP: code action")
  vim.keymap.set("v", "<leader>da", vim.lsp.buf.code_action)
  -- keymap({'i', 'v'}, "<leader>da", vim.lsp.buf.code_action, "LSP: code action", bufnr)
end

local mk_lsp_format_func = function(null_ls_format_only)
  null_ls_format_only = null_ls_format_only or false
  local format_config = {}

  if null_ls_format_only then
    format_config = {
      filter = function(client)
        return client.name == "null-ls"
      end,
    }
  else
    format_config = {}
  end

  return function()
    vim.lsp.buf.format(format_config)
  end
end

local lsp_keymap = function(bufnr)
  lsp_attach_keymap(bufnr)

  -- code search
  require("yen3.search").lsp_key_mapping(bufnr)
end

M.mk_lsp_on_attach_func = function(null_ls_format_only, extra_attach_func)
  return function(client, bufnr)
    require("lsp-status").on_attach(client)
    lsp_keymap(bufnr)

    -- lsp format
    keymap_n("<leader>bb", mk_lsp_format_func(null_ls_format_only), "LSP: format buffer", bufnr)

    if extra_attach_func ~= nil then
      extra_attach_func(client, bufnr)
    end
  end
end

M.lsp_create_config = function(extra_config, null_ls_format_only, extra_attach_func)
  local lsp_config = {
    on_attach = M.mk_lsp_on_attach_func(null_ls_format_only, extra_attach_func),
    capabilities = M.custom_update_capabilities(),
  }

  if extra_config ~= nil then
    lsp_config = vim.tbl_extend("force", lsp_config, extra_config)
  end

  return lsp_config
end

return M
