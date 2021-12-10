local M = {}

function M.dirname(str)
	if str:match(".-/.-") then
		local name = string.gsub(str, "(.*/)(.*)", "%1")
		return name
	else
		return ''
	end
end

function M.file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
 end

function M.find_config_path_rec(name)
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

function M.read_pyls_plugin_setting(path, sep)
  sep = sep or '[0-9a-z_]+'

  local config = {}
  for line in io.lines(path) do
      local line_config = {}
      for word in line:gmatch(sep) do
        table.insert(line_config, word)
      end
      if #line_config == 2 then
          local raw_value = line_config[2]
          local value = false
          if raw_value:lower() == 'true' then
            value = true
          end
          config[line_config[1]] = { enable = value }
      end

  end
  return config
end

return M
