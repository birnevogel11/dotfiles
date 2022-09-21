-- Credit: https://raw.githubusercontent.com/terrortylor/neovim-environment/lua_ftplugin_attempt/lua/util/config.lua
-- FIXME no tests
local api = vim.api

local M = {}

M.noremap_silent = {noremap = true, silent = true}

-- TODO remove once nvim 0.5
M.set_options = function(options)
  for k,v in pairs(options) do
    api.nvim_set_option(k, v)
  end
end

M.set_buf_options = function(options, buffer)
  buffer = buffer or 0
  for k,v in pairs(options) do
    api.nvim_buf_set_option(buffer, k, v)
  end
end

M.set_win_options = function(options, window)
  window = window or 0
  for k,v in pairs(options) do
    api.nvim_win_set_option(window, k, v)
  end
end

-- TODO remove once nvim 0.5
M.set_variables = function(variables)
  for k,v in pairs(variables) do
    api.nvim_set_var(k, v)
  end
end

M.create_keymap = function(mode, lhs, rhs, opts)
  -- change this from opts to ... and  loop on them to build up
  opts = opts or {noremap = true}
  api.nvim_set_keymap(mode, lhs, rhs, opts)
end

M.set_keymap_call = function(mode, lhs, callback)
  api.nvim_set_keymap(
    mode, lhs, "", {noremap = true, silent = true, callback=callback}
  )
end

M.set_keymap_call_n = function(lhs, callback)
  M.set_keymap_call("n", lhs, callback)
end

M.map_n = function(lhs, rhs, opts)
  opts = opts or {noremap = true, silent = true}
  api.nvim_set_keymap('n', lhs, rhs, opts)
end

M.buf_map_n = function(bufnr, key, value, opts)
  opts = opts or {noremap = true, silent = true}
  vim.api.nvim_buf_set_keymap(bufnr, 'n', key, value, opts)
end

M.lua_key_map = function(bufnr, mode, key, result)
  vim.api.nvim_buf_set_keymap(bufnr, mode, key, "<cmd>lua "..result.."<cr>",
    {noremap = true, silent = true})
end

return M
