local M = {}

local Path = require("plenary.path")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")

local custom_dirs_json_path = os.getenv("HOME") .. "/.config/yen3_local/nvim/custom_dirs.json"

local init_dir_table = function()
  local base_dirs = {
    cwd = "~/" .. Path:new(vim.fn.getcwd()):make_relative(vim.fn.fnamemodify("~", ":p")),
    vim = "~/usr/rc/vim",
    rc = "~/usr/rc",
  }

  return vim.tbl_extend("force", base_dirs, require("yen3.lib.file").read_json_file(custom_dirs_json_path))
end

local switch_cwd = function(dir_table)
  return function(prompt_bufnr)
    local selected = action_state.get_selected_entry()[1]
    local new_dir = dir_table[selected]
    vim.api.nvim_set_current_dir(new_dir)
    require("yen3.lib.notify").notify("Change cwd", selected .. " - " .. new_dir)

    actions.close(prompt_bufnr)
  end
end

M.setup = function()
  local dir_table = init_dir_table()

  local opts = {
    finder = finders.new_table(vim.tbl_keys(dir_table)),
    sorter = sorters.get_generic_fuzzy_sorter({}),
    attach_mappings = function(_, map)
      map("i", "<CR>", switch_cwd(dir_table))
      return true
    end,
  }

  M.custom_dir_search = function(theme_opts)
    local dir_search = pickers.new(theme_opts, opts)
    dir_search:find()
  end
end

return M
