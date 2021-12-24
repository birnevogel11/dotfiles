local window_util = require('yen3.util.window')
local config_util = require('yen3.util.config')

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
      width = window_util.get_float_window_width(),
      height = window_util.get_float_window_height(),
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

    prompt_prefix = "λ ",
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      preview_cutoff = 1, -- Preview should always show (unless previewer = false)

      width = window_util.get_float_window_width(),
      height = window_util.get_float_window_height(30),
      prompt_position = "bottom",
      preview_height = 15,
    },

    border = true,
  }

  return vim.tbl_deep_extend("force", theme_opts, opts)
end

M.telescope.default_theme_name = "require('yen3.search').telescope.theme_get_dropdown({})"
M.telescope.search_theme_name = "require('yen3.search').telescope.theme_search_preview({})"

function M.telescope.setup()
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
  M.telescope.map_n('<leader>ff', 'telescope.builtin', 'find_files')
  M.telescope.map_n('<leader>fg', 'telescope.builtin', 'git_files')
  M.telescope.map_n('<leader>fm', 'telescope',         'extensions.frecency.frecency')
  M.telescope.map_n('<leader>fb', 'telescope.builtin', 'buffers')

  M.telescope.map_n('<leader>fk', 'telescope.builtin', 'marks',         M.telescope.search_theme_name)
  M.telescope.map_n('<leader>fj', 'telescope.builtin', 'treesitter')

  M.telescope.map_n('<leader>fs', 'telescope.builtin', 'grep_string',   M.telescope.search_theme_name)
  M.telescope.map_n('<leader>fS', 'telescope.builtin', 'live_grep',     M.telescope.search_theme_name)

  M.telescope.map_n('<leader>fx', 'telescope.builtin', 'help_tags',     M.telescope.search_theme_name)
  M.telescope.map_n('<leader>fz', 'telescope.builtin', 'keymaps')
end

function M.telescope.lsp_key_mapping(bufnr)
  -- The function is called when lsp server is attached.
  M.telescope.buf_map_n(bufnr, '<c-]>',      'telescope.builtin', 'lsp_definitions',       M.telescope.search_theme_name)

  M.telescope.buf_map_n(bufnr, '<leader>fj', 'telescope.builtin', 'lsp_document_symbols')
  M.telescope.buf_map_n(bufnr, '<leader>fJ', 'telescope.builtin', 'lsp_workspace_symbols', M.telescope.search_theme_name)

  M.telescope.buf_map_n(bufnr, '<leader>fr', 'telescope.builtin', 'lsp_references',        M.telescope.search_theme_name)
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

function M.telescope.buf_map_n(bufnr, key, mod_name, fn_name, theme_name)
  ---@diagnostic disable-next-line: redefined-local
  local theme_name = theme_name or M.telescope.default_theme_name
  config_util.buf_map_n(bufnr, key, M.telescope.module_arg(mod_name, fn_name, theme_name))
end

function M.vim_float_term()
  config_util.set_variables {
    floaterm_opener = 'edit'
  }
end

function M.lf_vim()
  config_util.set_variables {
    lf_map_keys = 0,
    lf_width = window_util.get_float_window_width(),
    lf_height = window_util.get_float_window_height(),
  }

  config_util.map_n('<leader>fh',  ':Lf<cr>')
  config_util.map_n('<leader>fl', ':LfCurrentDirectory<cr>')
  config_util.map_n('<leader>fhc', ':Lfcd<cr>')
end

function M.setup()
  M.telescope.setup()
  M.vim_float_term()
  M.lf_vim()
end

return M
