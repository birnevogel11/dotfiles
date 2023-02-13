local M = {}

M.default_min_width = 80
M.default_min_height = 15

M.get_float_window_width = function(min_width)
  return math.max(vim.o.columns, min_width or M.default_min_width)
end

M.get_float_window_height = function(min_height)
  local height = vim.o.lines - vim.o.cmdheight
  if vim.o.laststatus ~= 0 then
    height = height - 1
  end

  return math.max(height, min_height or M.default_min_height)
end

M.enable_preview = function()
  return M.get_float_window_width() > 100
end

return M
