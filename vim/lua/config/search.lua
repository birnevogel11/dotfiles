local api = vim.api
local config_util = require('util.config')

local M = {}

function M.theme_get_dropdown(opts)
  opts = opts or {}

  local theme_opts = {
    theme = "dropdown_mini",
    sorting_strategy = "ascending",
    layout_strategy = "center",
    prompt_prefix = "λ ",
    prompt_title = "",
    preview_title = "",
    results_title = false,
    previewer = false,
    layout_config = {
      width = api.nvim_win_get_width(0),
      height = api.nvim_win_get_height(0),
    },
    border = false,
  }

  return vim.tbl_deep_extend("force", theme_opts, opts)
end

function M.telescope()
  require'telescope'.setup {
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      }
    }
  }
  require'telescope'.load_extension('fzy_native')
  require'telescope'.load_extension("frecency")

  local default_theme_name = "require('config.search').theme_get_dropdown({})"

  local module_arg = function(mod_name, fn_name, theme_name)
    ---@diagnostic disable-next-line: redefined-local
    local theme_name = theme_name or default_theme_name
    return "<cmd>lua require('" .. mod_name .."')." .. fn_name .. "(" .. theme_name .. ")<cr>"
  end

  local map_n = function(key, mod_name, fn_name, theme_name)
    ---@diagnostic disable-next-line: redefined-local
    local theme_name = theme_name or default_theme_name
    config_util.create_keymap('n', key, module_arg(mod_name, fn_name, theme_name))
  end

  map_n('<C-P>',      'telescope.builtin', 'find_files')
  map_n('<leader>dg', 'telescope.builtin', 'git_files')
  map_n('<leader>o',  'telescope.builtin', 'treesitter')
  map_n('<leader>dh', 'telescope.builtin', 'help_tags')
  map_n('<leader>dm', 'telescope',         'extensions.frecency.frecency')
end

function M.lf_vim()
  config_util.set_variables {
    lf_map_keys = 0,
    lf_width = vim.fn.winwidth('%') - 5,
    lf_height = vim.fn.winheight('%') - 3,
  }

  config_util.create_keymap('n', '<leader>f',  ':Lf<cr>')
  config_util.create_keymap('n', '<leader>ff', ':LfCurrentDirectory<cr>')
  config_util.create_keymap('n', '<leader>fc', ':Lfcd<cr>')
end

function M.vim_fzf()
  config_util.set_variables {
    fzf_preview_window = {'up:50%', 'ctrl-/'},
    fzf_layout = {
      window =  {
        width = 1.0,
        height = 1.0,
        border = 'no'
      },
    },
    fzf_buffers_jump = 1,
  }
end

function M.setup()
  M.telescope()
  M.lf_vim()
  M.vim_fzf()
end

return M
