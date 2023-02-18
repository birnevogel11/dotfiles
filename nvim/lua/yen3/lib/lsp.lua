local M = {}

local get_buf_activated_lsp = function()
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return nil
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 and client.name ~= "null-ls" then
      return client.name
    end
  end
  return nil
end

M.get_activated_lsp = function()
  local lsp_name = get_buf_activated_lsp()
  if lsp_name == nil then
    return "No Active LSP"
  end

  return lsp_name .. "  " .. (require("lsp-status").status_progress() or "")
end

return M
