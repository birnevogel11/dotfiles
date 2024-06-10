-- Credit: https://github.com/nvim-telescope/telescope-z.nvim/blob/main/lua/telescope/_extensions/z_builtin.lua
-- The file is copied from the url and modify some functions.
local M = {}

local Path = require("plenary.path")

local actions = require("telescope.actions")
local actions_set = require("telescope.actions.set")
local actions_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local from_entry = require("telescope.from_entry")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers.term_previewer")
local utils = require("telescope.utils")

local os_home = vim.loop.os_homedir()
local init_cwd = "~/" .. Path:new(vim.fn.getcwd()):make_relative(vim.fn.fnamemodify("~", ":p"))

local simpiify_path = function(path)
  if vim.startswith(path, os_home) then
    path = Path:new("~/") .. Path:new(path):make_relative(os_home)
  end

  return path
end

local gen_from_z = function()
  local displayer = entry_display.create({
    separator = " ",
    items = { { remaining = true } },
  })

  return function(line)
    return {
      ordinal = line,
      path = line,
      display = function(entry)
        return displayer({
          simpiify_path(entry.path),
        })
      end,
    }
  end
end

M.jump_back_init_cwd = function()
  vim.cmd("cd " .. init_cwd)
  require("bv11.lib.notify").notify("Chdir to original", simpiify_path(init_cwd))
end

M.dirs = function(ori_opts)
  local opts = ori_opts or {}
  opts = vim.fn.copy(opts)

  local cmd = nil
  cmd = vim.F.if_nil(opts.cmd, {
    vim.o.shell,
    "-c",
    "jumper -f ~/.jumper/jfolders",
  })
  opts.cwd = utils.get_lazy_default(opts.cwd, vim.loop.cwd)
  opts.entry_maker = opts.entry_maker or gen_from_z()

  pickers
    .new(opts, {
      finder = finders.new_table({
        results = utils.get_os_command_output(cmd),
        entry_maker = opts.entry_maker,
      }),
      sorter = conf.generic_sorter(opts),
      previewer = previewers.cat.new(opts),
      attach_mappings = function(prompt_bufnr)
        actions_set.select:replace(function(_, type)
          local entry = actions_state.get_selected_entry()
          local dir = from_entry.path(entry)
          if type == "default" then
            require("telescope.builtin").find_files(vim.tbl_extend("keep", ori_opts, { cwd = dir, hidden = true }))
            return
          elseif type == "vertical" then
            require("telescope.builtin").live_grep(vim.tbl_extend("keep", ori_opts, { cwd = dir, hidden = true }))
            return
          end
          actions.close(prompt_bufnr)
          if type == "tab" then
            vim.cmd("cd " .. dir)
            require("bv11.lib.notify").notify("Chdir to", simpiify_path(dir))
          end
        end)
        return true
      end,
    })
    :find()
end

M.files = function(ori_opts)
  local opts = ori_opts or {}
  opts = vim.fn.copy(opts)

  local cmd = nil
  cmd = vim.F.if_nil(opts.cmd, {
    vim.o.shell,
    "-c",
    "jumper -f ~/.jumper/jfiles",
  })
  opts.cwd = utils.get_lazy_default(opts.cwd, vim.loop.cwd)
  opts.entry_maker = opts.entry_maker or gen_from_z()

  pickers
    .new(opts, {
      finder = finders.new_table({
        results = utils.get_os_command_output(cmd),
        entry_maker = opts.entry_maker,
      }),
      sorter = conf.generic_sorter(opts),
      previewer = conf.file_previewer(opts),
    })
    :find()
end

return M
