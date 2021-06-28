local api = vim.api
local M = {}
local config_util = require('util.config')

function M.theme_get_dropdown(opts)
  opts = opts or {}

  local theme_opts = {
    -- WIP: Decide on keeping these names or not.
    theme = "dropdown_mini",

    sorting_strategy = "ascending",
    layout_strategy = "center",

    prompt_prefix = "λ ",

    -- Disable all title
    prompt_title = "",
    preview_title = "",
    results_title = false,

    previewer = false,
    -- preview_cutoff = 1, -- Preview should always show (unless previewer = false)

    width = api.nvim_win_get_width(0),
    height = api.nvim_win_get_height(0),

    results_height = 30,
    border = false,
  }

  return vim.tbl_deep_extend("force", theme_opts, opts)
end

function M.telescope()
  require('telescope').setup {
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
  }
  require('telescope').load_extension('fzy_native')
  require"telescope".load_extension("frecency")

  local default_theme_name = "require('config.telescope').theme_get_dropdown({})"

  local module_arg = function(mod_name, fn_name, theme_name)
    local theme_name = theme_name or default_theme_name
    return "<cmd>lua require('" .. mod_name .."')." .. fn_name .. "(" .. theme_name .. ")<cr>"
  end

  local map_n = function(key, mod_name, fn_name, theme_name)
    local theme_name = theme_name or default_theme_name
    config_util.create_keymap('n', key, module_arg(mod_name, fn_name, theme_name))
  end

  map_n('<C-P>', 'telescope.builtin', 'find_files')
  map_n('<leader>dh', 'telescope.builtin', 'help_tags')
  config_util.create_keymap('n', '<leader>dm', "<cmd>lua require('telescope').extensions.frecency.frecency(require('config.telescope').theme_get_dropdown())<cr>")
  -- config_util.create_keymap('n', '<leader>ds', ":lua require'telescope.builtin'.grep_string(require('config.telescope').theme_get_dropdown_search())<cr>")
end

function M.setup()
  M.telescope()
end

return M
