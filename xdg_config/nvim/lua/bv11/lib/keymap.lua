local M = {}

--- Create a keymap
---@param mode string|table map mode
---@param lhs string keymap
---@param rhs any|string map target. It could be a function or a string
---@param desc string|nil map destription
---@param buffer integer|nil the buffer number
M.keymap = function(mode, lhs, rhs, desc, buffer)
  vim.keymap.set(mode, lhs, rhs, { remap = false, silent = true, desc = desc, buffer = buffer or nil })
end


--- Create a normal keymap
---@param lhs string keymap
---@param rhs any|string map target. It could be a function or a string
---@param desc string|nil map destription
---@param buffer integer|nil the buffer number
M.keymap_n = function(lhs, rhs, desc, buffer)
  M.keymap("n", lhs, rhs, desc, buffer)
end

return M
