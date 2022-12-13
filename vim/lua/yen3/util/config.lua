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

M.notify_async = function(title, msg, log_level)
  require("notify").async(msg, log_level or "info", {title = title})
end

M.async_cmd_notify = function(cmd, title, handle_output, cwd)
  local Job = require('plenary.job')
  local notify = require("notify")

  handle_output = handle_output or function(j)
    return M.list_to_lines({M.list_to_lines(j:result()), M.list_to_lines(j:stderr_result())})
  end

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

      M.notify(title, handle_output(j), log_level)
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

M.read_json_file = function(raw_path)
  local Path = require('plenary.path')

  local path = Path:new(raw_path)
  if not path:exists() then
    return {}
  end

  return vim.fn.json_decode(path:read())
end

return M
