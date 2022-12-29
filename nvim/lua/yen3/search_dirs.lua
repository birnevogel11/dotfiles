-- Credit: https://github.com/nvim-telescope/telescope-z.nvim/blob/main/lua/telescope/_extensions/z_builtin.lua
-- The file is copied from the url and modify some functions.
local M = {}

local Path = require("plenary.path")

local actions = require("telescope.actions")
local actions_set = require'telescope.actions.set'
local actions_state = require'telescope.actions.state'
local conf = require'telescope.config'.values
local entry_display = require'telescope.pickers.entry_display'
local finders = require("telescope.finders")
local from_entry = require'telescope.from_entry'
local pickers = require("telescope.pickers")
local previewers = require'telescope.previewers.term_previewer'
local utils = require'telescope.utils'

local os_home = vim.loop.os_homedir()

local simpiify_path = function(path)
  if vim.startswith(path, os_home) then
    path = Path:new("~/") .. Path:new(path):make_relative(os_home)
  end

  return path
end

local gen_from_z = function()
  local displayer = entry_display.create({
    separator = ' ',
    items = { {remaining = true} },
  })

  return function(line)
    local score_str, dir = line:match('(%d+)[ \t\n]+(.*)')
    local score = tonumber(score_str)

    return {
      value = score,
      ordinal = dir,
      path = dir,
      display = function(entry)
        return displayer{
          simpiify_path(entry.path),
        }
      end
    }
  end
end

M.telescope_z_custom = function(ori_opts)
  local opts = vim.fn.copy(vim.F.if_nil(ori_opts, {}))
  local cmd = vim.F.if_nil(opts.cmd,
    {vim.o.shell, '-c', 'source ~/.local/share/zinit/plugins/agkozak---zsh-z/zsh-z.plugin.zsh && zshz -l | tail -r'})
  opts.cwd = utils.get_lazy_default(opts.cwd, vim.loop.cwd)
  opts.entry_maker = opts.entry_maker or gen_from_z()

  pickers.new(opts, {
    finder = finders.new_table{
      results = utils.get_os_command_output(cmd),
      entry_maker = opts.entry_maker,
    },
    sorter = conf.file_sorter(opts),
    previewer = previewers.cat.new(opts),
    attach_mappings = function(prompt_bufnr)
      actions_set.select:replace(function(_, type)
        local entry = actions_state.get_selected_entry()
        local dir = from_entry.path(entry)
        if type == 'default' then
          require('telescope.builtin').find_files(vim.tbl_extend("keep", ori_opts, {cwd = dir, hidden = true}))
          return
        end
        actions.close(prompt_bufnr)
        if type == 'tab' then
          vim.cmd('cd '.. dir)
          require("yen3.lib.notify").notify("Chdir to", simpiify_path(dir))
        end
      end)
      return true
    end,
  }):find()
end

return M
