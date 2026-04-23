local M = {}

local disable_read_only_warning = function()
  vim.api.nvim_create_autocmd("FileChangedRO", {
    group = vim.api.nvim_create_augroup("bv11_NoReadOnlyWarning", { clear = true }),
    command = "set noreadonly",
  })
end

local show_cursor_line_in_current_window_only = function()
  local group = vim.api.nvim_create_augroup("bv11_SetCursorLineCurrentWindow", { clear = true })
  vim.api.nvim_create_autocmd(
    { "VimEnter", "WinEnter", "BufWinEnter" },
    { command = "setlocal cursorline", group = group }
  )
  vim.api.nvim_create_autocmd("WinLeave", { command = "setlocal nocursorline", group = group })
end

local resize_splits_when_window_changes = function()
  vim.api.nvim_create_autocmd("VimResized", {
    command = ":wincmd =",
    group = vim.api.nvim_create_augroup("bv11_ResizeWindow", { clear = true }),
  })
end

local highlight_yanked_region = function()
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("bv11_highlight_yank", { clear = true }),
    callback = function()
      vim.highlight.on_yank({ higroup = "HighlightedyankRegion", timeout = 100 })
    end,
  })
end

M.setup = function()
  disable_read_only_warning()
  show_cursor_line_in_current_window_only()
  resize_splits_when_window_changes()
  highlight_yanked_region()
end

return M
