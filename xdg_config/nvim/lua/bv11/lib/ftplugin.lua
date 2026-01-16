local M = {}

---Set the filetype's indention
---@param tab_width integer?
---@param textwidth integer?
M.indention_setup = function(tab_width, textwidth)
  tab_width = tab_width or 2
  textwidth = textwidth or 79

  vim.opt_local.shiftwidth = tab_width
  vim.opt_local.tabstop = tab_width
  vim.opt_local.softtabstop = tab_width
  vim.opt_local.expandtab = true
  vim.opt_local.textwidth = textwidth
  vim.opt_local.wrap = true
  -- vim.opt_local.fileformat = "unix"
end

return M
