local M = {}
local config_util = require('yen3.util.config')

M._get_spell_paths = function(extra_paths)
  local home_dir = vim.fn.fnamemodify('~', ':p')
  local paths = {
    home_dir .. "/usr/rc/vim/spelunker/common.txt",
    home_dir .. "/usr/rc/vim/spelunker/python.txt",
  }
  if extra_paths then
    for _, path in ipairs(extra_paths) do
      paths = vim.fn.insert(paths, path)
    end
  end

  return paths
end

M._read_word_list = function(paths)
  local words = {}
  for _, path in ipairs(paths) do
    for _, word in ipairs(vim.fn.readfile(path)) do
      words = vim.fn.insert(words, word)
    end
  end

  return words
end

M.enable_spelunker = function(extra_paths)
  local words = M._read_word_list(M._get_spell_paths(extra_paths))

  config_util.set_variables {
    enable_spelunker_vim = 1,
    spelunker_white_list_for_user = words,
  }
end

M.spelunker_vim = function()
  config_util.set_variables({ enable_spelunker_vim = 0 })
end


M.setup = function()
  M.spelunker_vim()
end

return M
