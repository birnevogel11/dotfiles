local M = {}

local get_pyenv_virtualenv_bin_dir = function()
  if vim.fn.executable("pyenv") ~= 1 then
    return nil
  end

  local raw_name = vim.fn.system({ "pyenv", "version" })
  local virtualenv_name = ""
  for token in raw_name:gmatch("%S+") do
    virtualenv_name = token
    break
  end

  return os.getenv("HOME") .. "/.pyenv/versions/" .. virtualenv_name .. "/bin"
end

M.get_pyenv_virtualenv_bin_path = function(bin_name)
  local bin_dir = get_pyenv_virtualenv_bin_dir()
  if bin_dir ~= nil then
    return bin_dir .. "/" .. bin_name
  else
    return nil
  end
end

return M
