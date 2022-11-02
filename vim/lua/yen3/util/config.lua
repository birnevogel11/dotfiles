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

M.map_call = function(mode, lhs, callback)
  api.nvim_set_keymap(mode, lhs, "", {noremap = true, silent = true, callback=callback})
end

M.map_n = function(lhs, rhs, opts)
  api.nvim_set_keymap('n', lhs, rhs, opts or {noremap = true, silent = true})
end

M.buf_map_n = function(bufnr, key, value, opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', key, value, opts or {noremap = true, silent = true})
end

M.map_call_n = function(lhs, callback)
  M.map_call("n", lhs, callback)
end

M.buf_map_call = function(bufnr, mode, lhs, callback)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, "", {noremap = true, silent = true, callback = callback})
end

M.buf_map_call_n = function(bufnr, lhs, callback)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, "", {noremap = true, silent = true, callback = callback})
end

M.list_to_lines = function (tbl)
  local result = ""

  for _, line in ipairs(tbl) do
    if result == "" then
      result = line
    else
      result = result .. "\n" .. line
    end
  end

  return result
end

M.notify = function(title, msg, log_level)
  require("notify")(msg, log_level or "info", {title = title})
end

M.async_cmd_notify = function(cmd, title, cwd)
  local Job = require('plenary.job')
  local notify = require("notify")

  if type(cmd) ~= "table" then
    notify("cmd is not a table", "error", {title = "aysnc_cmd_notify"})
    return
  end

  local command = table.remove(cmd, 1)
  Job:new({
    command = command,
    args = cmd,
    cwd = cwd,
    on_exit = function(j, return_val)
      local log_level = ""
      if return_val == 0 then
        log_level = "info"
      else
        log_level = "error"
      end

      local msg = M.list_to_lines({M.list_to_lines(j:result()), M.list_to_lines(j:stderr_result())})
      M.notify(title, msg, log_level)
    end
  }):start()
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
