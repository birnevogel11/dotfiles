-- disable_read_only_warning
vim.api.nvim_create_autocmd("FileChangedRO", {
  group = vim.api.nvim_create_augroup("bv11_NoReadOnlyWarning", { clear = true }),
  command = "set noreadonly",
})

-- resize_splits_when_window_changes
vim.api.nvim_create_autocmd("VimResized", {
  command = ":wincmd =",
  group = vim.api.nvim_create_augroup("bv11_ResizeWindow", { clear = true }),
})

-- highlight_yanked_region
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("bv11_highlight_yank", { clear = true }),
  callback = function()
    vim.hl.hl_op({higroup = "HighlightedyankRegion", timeout = 100})
  end,
})

local show_cursor_line_in_current_window_only = function()
  local group = vim.api.nvim_create_augroup("bv11_SetCursorLineCurrentWindow", { clear = true })
  vim.api.nvim_create_autocmd(
    { "VimEnter", "WinEnter", "BufWinEnter" },
    { callback = function() vim.opt_local.cursorline = true end, group = group }
  )
  vim.api.nvim_create_autocmd("WinLeave", { callback = function() vim.opt_local.cursorline = false end, group = group })
end

show_cursor_line_in_current_window_only()
