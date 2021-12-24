local M = {}

M.default_min_width = 80
M.default_min_height = 15

function M.get_float_window_width(min_width)
  return math.max(vim.o.columns, min_width or M.default_min_width)
end

function M.get_float_window_height(min_height)
  local height = vim.o.lines - vim.o.cmdheight
  if vim.o.laststatus ~= 0 then
    height = height - 1
  end

  return math.max(height, min_height or M.default_min_height)
end

return M
