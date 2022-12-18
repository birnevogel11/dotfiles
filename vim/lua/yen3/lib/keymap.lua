local api = vim.api

local M = {}

M.keymap = function(mode, lhs, rhs, desc, buffer)
  vim.keymap.set(mode, lhs, rhs, { remap = false, silent = true, desc = desc, buffer = buffer or nil })
end

M.keymap_n = function(lhs, rhs, desc, buffer)
  M.keymap("n", lhs, rhs, desc, buffer)
end

return M
