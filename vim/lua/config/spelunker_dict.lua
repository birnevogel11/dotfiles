local M = {}
local config_util = require('util.config')

-- see if the file exists
-- Ref: https://stackoverflow.com/questions/11201262/how-to-read-data-from-a-file-in-lua
function M.file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- Ref: https://stackoverflow.com/questions/11201262/how-to-read-data-from-a-file-in-lua
function M.lines_multi_files(paths)
  lines = {}

  for _, path in ipair(paths) do
    if M.file_exists(path) then
        for line in io.lines(path) do
          lines[#lines + 1] = line
        end
    end
  end

  return lines
end

function M.enable_spelunker(paths)
  local vars = {
    spelunker_white_list_for_user = M.lines_multi_files(paths),
    enable_spelunker_vim = 1,
  }

  config_util.set_variables(vars)
end

return M
