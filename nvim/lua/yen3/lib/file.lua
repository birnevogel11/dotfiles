local M = {}

M.read_json_file = function(raw_path)
  local Path = require("plenary.path")

  local path = Path:new(raw_path)
  if not path:exists() then
    return {}
  end

  return vim.fn.json_decode(path:read())
end

return M
