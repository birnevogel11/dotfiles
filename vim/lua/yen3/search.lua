local telescope = require("telescope")

local window_util = require("yen3.util.window")
local config_util = require("yen3.util.config")
local map_n = config_util.map_call_n
local buf_map_n = config_util.buf_map_call_n

local M = {
  telescope = {}
}

local theme_get_dropdown = function(opts)
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

local theme_search_preview = function(opts)
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

local mod_func = function(module_name, function_name, theme_func, opt)
  theme_func = theme_func or M.default_theme
  return function()
    require(module_name)[function_name](theme_func(opt or {}))
  end
end

M.key_mapping = function()
  map_n("<leader>ff", mod_func("telescope.builtin", "find_files"))
  map_n("<leader>fm", function() telescope.extensions.frecency.frecency(M.default_theme({})) end)
  map_n("<leader>fb", mod_func("telescope.builtin", "buffers"))

  map_n("<leader>fk", mod_func("telescope.builtin", "marks", M.search_theme))
  map_n("<leader>fj", mod_func("telescope.builtin", "treesitter"))
  map_n("<leader>fg", mod_func("telescope.builtin", "live_grep", M.search_theme))
  config_util.map_call("v", "<leader>fg", function()
    require('telescope.builtin').live_grep(M.search_theme({ default_text = config_util.get_visual_selection() }))
  end)
  map_n("<leader>fs", mod_func("telescope.builtin", "grep_string", M.search_theme))

  map_n("<leader>fx", mod_func("telescope.builtin", "help_tags", M.search_theme))
  map_n("<leader>fz", mod_func("telescope.builtin", "keymaps"))
  map_n("<leader>fy", function() telescope. extensions.neoclip.neoclip(M.search_theme({})) end)

  map_n("<leader>ft", mod_func("telescope.builtin", "diagnostics", M.search_theme))
  map_n("<leader>fu", mod_func("telescope.builtin", "commands"))
  map_n("<leader>fn", function() require('telescope').extensions.notify.notify(M.search_theme({})) end)
end

-- The function is called when lsp server is attached.
M.lsp_key_mapping = function(bufnr)
  buf_map_n(bufnr, "<c-]>",      mod_func("telescope.builtin", "lsp_definitions", M.search_theme))
  buf_map_n(bufnr, "<leader>fj", mod_func("telescope.builtin", "lsp_document_symbols", M.default_theme))
  buf_map_n(bufnr, "<leader>fJ", mod_func("telescope.builtin", "lsp_workspace_symbols", M.search_theme))
  buf_map_n(bufnr, "<leader>fr", mod_func("telescope.builtin", "lsp_references", M.default_theme))
end

M.default_theme = theme_get_dropdown
M.search_theme = theme_search_preview

M.telescope.setup = function()
  telescope.setup({
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    },
  })
  telescope.load_extension("fzy_native")
  telescope.load_extension("frecency")
  telescope.load_extension("gh")
  telescope.load_extension('neoclip')

  vim.cmd([[ autocmd User TelescopePreviewerLoaded setlocal number relativenumber wrap list ]])

  M.key_mapping()
end

M.neo_tree_nvim = function()
  require("neo-tree").setup({
    window = {
      width = 30,
      mappings = {
        ["<space>"] = "toggle_node",
        ["l"] = "open",
        ["<cr>"] = "open",
        ["S"] = "open_split",
        ["s"] = "open_vsplit",
        ["h"] = "close_node",
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["R"] = "refresh",
        ["/"] = "fuzzy_finder",
        ["f"] = "filter_on_submit",
        ["<c-x>"] = "clear_filter",
        ["a"] = "add",
        ["A"] = "add_directory",
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = "copy", -- takes text input for destination
        ["m"] = "move", -- takes text input for destination
        ["q"] = "close_window",
      }
    },
    filesystem = {
      filtered_items = {
        never_show = { -- remains hidden even if visible is toggled to true
          ".DS_Store",
          "thumbs.db",
        },
      },
    },
  })

  map_n("<leader>fv", ":NeoTreeRevealToggle<cr>")
  map_n("<leader>fV", ":Neotree float<cr>")
end

return M
