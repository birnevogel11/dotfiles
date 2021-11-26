local api = vim.api
local config_util = require('util.config')

local M = {}
M.telescope = {}

function M.telescope.theme_get_dropdown(opts)
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

function M.telescope.theme_search_preview(opts)
  opts = opts or {}

  local theme_opts = {
    theme = "vertical_search_preview",

    results_title = false,

    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      preview_cutoff = 1, -- Preview should always show (unless previewer = false)

      width = api.nvim_win_get_width(0),
      height = math.max(api.nvim_win_get_height(0) - 15, 30),
      prompt_position = "bottom",
      preview_height = 15,
    },

    border = true,
  }

  return vim.tbl_deep_extend("force", theme_opts, opts)
end

M.telescope.default_theme_name = "require('yen3.search').telescope.theme_get_dropdown({})"
M.telescope.search_theme_name = "require('yen3.search').telescope.theme_search_preview({})"

function M.telescope.config()
  require'telescope'.setup {
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    }
  }
  require'telescope'.load_extension('fzy_native')
  require'telescope'.load_extension("frecency")
  require'telescope'.load_extension('gh')

  vim.cmd([[ autocmd User TelescopePreviewerLoaded setlocal number relativenumber wrap list ]])

  M.telescope.key_mapping()
end

function M.telescope.key_mapping()
  M.telescope.map_n('<C-P>',      'telescope.builtin', 'find_files')
  M.telescope.map_n('<leader>dg', 'telescope.builtin', 'git_files')
  M.telescope.map_n('<leader>db', 'telescope.builtin', 'buffers')
  M.telescope.map_n('<leader>dk', 'telescope.builtin', 'marks')
  M.telescope.map_n('<leader>do', 'telescope.builtin', 'telescope')
  M.telescope.map_n('<leader>dh', 'telescope.builtin', 'help_tags')
  M.telescope.map_n('<leader>dz', 'telescope.builtin', 'keymaps')
  M.telescope.map_n('<leader>dm', 'telescope',         'extensions.frecency.frecency')
  M.telescope.map_n('<leader>ds', 'telescope.builtin', 'grep_string',   M.telescope.search_theme_name)
  M.telescope.map_n('<leader>ds', 'telescope.builtin', 'live_grep',     M.telescope.search_theme_name)
end

function M.telescope.lsp_key_mapping()
  -- The function is called when lsp server is attached
  M.telescope.map_n('<leader>do', 'telescope.builtin', 'lsp_document_symbols')
end

function M.telescope.module_arg(mod_name, fn_name, theme_name)
    ---@diagnostic disable-next-line: redefined-local
  local theme_name = theme_name or M.telescope.default_theme_name
  return "<cmd>lua require('" .. mod_name .."')." .. fn_name .. "(" .. theme_name .. ")<cr>"
end

function M.telescope.map_n(key, mod_name, fn_name, theme_name)
  ---@diagnostic disable-next-line: redefined-local
  local theme_name = theme_name or M.telescope.default_theme_name
  config_util.map_n(key, M.telescope.module_arg(mod_name, fn_name, theme_name))
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

function M.lf_vim()
  config_util.set_variables {
    lf_map_keys = 0,
    lf_width = vim.fn.winwidth('%') - 5,
    lf_height = vim.fn.winheight('%') - 3,
  }

  config_util.map_n('<leader>f',  ':Lf<cr>')
  config_util.map_n('<leader>ff', ':LfCurrentDirectory<cr>')
  config_util.map_n('<leader>fc', ':Lfcd<cr>')
end

function M.setup()
  M.telescope.config()
  M.vim_fzf()
  M.lf_vim()
end

return M
