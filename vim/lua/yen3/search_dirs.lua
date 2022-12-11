local M = {}

local Path = require('plenary.path')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local dropdown = require('telescope.themes').get_dropdown()

local config_util = require('yen3.util.config')

local custom_dirs_json_path = vim.fn.fnamemodify('~', ':p') ..
  ".config/yen3_local/nvim/custom_dirs.json"

local get_keys_from_table = function(raw_table)
  local keys = {}
  for k, _ in pairs(raw_table) do
    keys[#keys + 1] = k
  end

  return keys
end

local init_dir_table = function()
  local base_dirs = {
    cwd = "~/" .. Path:new(vim.fn.getcwd()):make_relative(vim.fn.fnamemodify('~', ':p')),
    vim = "~/usr/rc/vim",
    rc = "~/usr/rc",
  }

  return vim.tbl_extend("force", base_dirs, config_util.read_json_file(custom_dirs_json_path))
end

local dir_table = init_dir_table()

---@diagnostic disable-next-line: unused-local
local swtich_cwd = function(prompt_bufnr)
  local selected = action_state.get_selected_entry()
  local new_dir = dir_table[selected[1]]
  vim.api.nvim_set_current_dir(new_dir)
  config_util.notify("Change cwd", new_dir)

  actions.close(prompt_bufnr)
end

M.setup = function()
  local opts = {
    finder = finders.new_table(get_keys_from_table(dir_table)),
    sorter = sorters.get_generic_fuzzy_sorter({}),
    attach_mappings = function(prompt_bunr, map)
      map('i', '<CR>', swtich_cwd)
      return true
    end
  }

  M.custom_dir_search = function(theme_opts)
    local dir_search = pickers.new(theme_opts, opts)
    dir_search:find()
  end
end

return M
