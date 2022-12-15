local M = {}

M.dirname = function(str)
	if str:match(".-/.-") then
		local name = string.gsub(str, "(.*/)(.*)", "%1")
		return name
	else
		return ''
	end
end

M.file_exists = function(name)
   local f = io.open(name,"r")
   if f ~= nil then
     io.close(f)
     return true
   end

   return false
 end

M.find_config_path_rec = function(name)
  local home_dir = vim.fn.fnamemodify('~', ':p')

  local search_dir = vim.fn.getcwd() .. '/'
  local counter = 0
  while search_dir ~= home_dir and counter < 5 do
    local path = search_dir .. name
    if M.file_exists(path) then
      return path
    end
    search_dir = M.dirname(string.sub(search_dir, 0, #search_dir-1))
    counter = counter + 1
  end

  return ''
end

M.get_home_dir = function()
  return vim.fn.fnamemodify("~", ":p"):sub(1, -2)
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
