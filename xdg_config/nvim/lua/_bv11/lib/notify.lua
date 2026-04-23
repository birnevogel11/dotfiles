local M = {}

local list_to_lines = function(tbl)
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

---@param title string
---@param msg string
---@param log_level string?
M.notify = function(title, msg, log_level)
  Snacks.notify(msg, {
    title = title,
    level = log_level or "info"
  })
end


M.async_cmd_notify = function(cmd, title, handle_output, cwd)
  local Job = require("plenary.job")
  local notify = require("notify")

  handle_output = handle_output
    or function(j)
      return list_to_lines({ list_to_lines(j:result()), list_to_lines(j:stderr_result()) })
    end

  if type(cmd) ~= "table" then
    notify("cmd is not a table", "error", { title = "aysnc_cmd_notify" })
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
    end,
  }):start()
end

return M
