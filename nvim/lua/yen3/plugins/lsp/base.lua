local nvim_status = require("lsp-status")
local keymap_n = require("yen3.lib.keymap").keymap_n

local M = {}

local get_buf_activated_lsp = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if next(clients) == nil then
    return nil
  end

  local client_names = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
  end

  return client_names
end

M.get_activated_lsp = function()
  local lsp_names = get_buf_activated_lsp()
  if lsp_names == nil then
    return "No Active LSP"
  end

  local info_lines = vim.fn.copy(lsp_names) or {}
  local progress = require("lsp-status").status_progress() or ""
  if progress ~= "" then
    table.insert(info_lines, progress)
  end

  return vim.fn.join(info_lines, "\n")
end

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

local lsp_keymap = function(bufnr)
  lsp_attach_keymap(bufnr)

  -- code search
  require("yen3.plugins.search.base").lsp_key_mapping(bufnr)
end

local init_lsp_create_opts = function(opts)
  local default_opts = {
    extra_config = nil,
    extra_attach_func = nil,
    use_lsp_syntax_highlight = false,
    enable_inlay_hint = false,
  }

  return vim.tbl_deep_extend("force", default_opts, opts or {})
end

M.mk_lsp_on_attach_func = function(opts)
  opts = init_lsp_create_opts(opts)

  return function(client, bufnr)
    -- Disable lsp syntax highlight
    if opts.use_lsp_syntax_highlight ~= true then
      client.server_capabilities.semanticTokensProvider = nil
    end

    require("lsp-status").on_attach(client)
    lsp_keymap(bufnr)

    if opts.enalbe_inlay_hint == true then
      vim.lsp.inlay_hint.enable(bufnr, true)
    end

    if opts.extra_attach_func ~= nil then
      opts.extra_attach_func(client, bufnr)
    end
  end
end

M.lsp_create_config = function(opts)
  -- opts = {
  --    extra_config = nil,
  --    extra_attach_func = nil,
  --    null_ls_format_only = false,
  --    use_lsp_syntax_highlight = false,
  --    enable_inlay_hint = false,
  -- }
  opts = init_lsp_create_opts(opts)

  local lsp_config = {
    on_attach = M.mk_lsp_on_attach_func(opts),
    capabilities = M.custom_update_capabilities(),
  }

  if opts.extra_config ~= nil then
    lsp_config = vim.tbl_extend("force", lsp_config, opts.extra_config)
  end

  -- if opts.enable_inlay_hint == true then
  --   vim.lsp.inlay_hint.enable(0, true)
  -- end

  return lsp_config
end

return M
