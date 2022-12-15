-- Credit: https://raw.githubusercontent.com/terrortylor/neovim-environment/lua_ftplugin_attempt/lua/util/config.lua
local api = vim.api

local M = {}

M.set_variables = function(variables)
  for k,v in pairs(variables) do
    api.nvim_set_var(k, v)
  end
end

M.map = function(mode, lhs, rhs, opts)
  api.nvim_set_keymap(mode, lhs, rhs, opts or {noremap = true})
end

M.map_call = function(mode, lhs, callback, desc)
  api.nvim_set_keymap(mode, lhs, "", {noremap = true, silent = true, callback = callback, desc = desc})
end

M.map_n = function(lhs, rhs, desc)
  api.nvim_set_keymap('n', lhs, rhs, {noremap = true, silent = true, desc = desc})
end

M.buf_map_n = function(bufnr, key, value, desc)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', key, value, {noremap = true, silent = true, desc = desc})
end

M.map_call_n = function(lhs, callback, desc)
  M.map_call("n", lhs, callback, desc)
end

M.buf_map_call = function(bufnr, mode, lhs, callback, desc)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, "", {noremap = true, silent = true, callback = callback, desc = desc})
end

M.buf_map_call_n = function(bufnr, lhs, callback, desc)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, "", {noremap = true, silent = true, callback = callback, desc = desc})
end

M.get_visual_selection = function()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg('v')
	vim.fn.setreg('v', {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ''
	end
end

return M
