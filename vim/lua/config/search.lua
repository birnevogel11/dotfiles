local api = vim.api
local config_util = require('util.config')

local M = {}

function M.lf_vim()
  local width = vim.fn.winwidth('%') - 5
  local height = vim.fn.winheight('%') - 3

  local vars = {
    lf_map_keys = 0,
    lf_width = vim.fn.winwidth('%') - 5,
    lf_height = vim.fn.winheight('%') - 3,
  }

  config_util.set_variables(vars)

  config_util.create_keymap('n', '<leader>f',  ':Lf<cr>')
  config_util.create_keymap('n', '<leader>ff', ':LfCurrentDirectory<cr>')
  config_util.create_keymap('n', '<leader>fc', ':Lfcd<cr>')
end

function M.setup()
  M.lf_vim()
end

return M
