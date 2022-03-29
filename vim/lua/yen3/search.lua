local window_util = require("yen3.util.window")
local config_util = require("yen3.util.config")

local M = {}
M.telescope = {}

M.telescope.theme_get_dropdown = function(opts)
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

M.telescope.theme_search_preview = function(opts)
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

M.telescope.setup = function()
  require("telescope").setup({
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    },
  })
  require("telescope").load_extension("fzy_native")
  require("telescope").load_extension("frecency")
  require("telescope").load_extension("gh")
  require('telescope').load_extension('neoclip')

  vim.cmd([[ autocmd User TelescopePreviewerLoaded setlocal number relativenumber wrap list ]])

  M.telescope.key_mapping()
end

M.telescope.key_mapping = function()
  M.telescope.map_n("<leader>ff", "telescope.builtin", "find_files")
  M.telescope.map_n("<leader>fm", "telescope", "extensions.frecency.frecency")
  M.telescope.map_n("<leader>fb", "telescope.builtin", "buffers")

  M.telescope.map_n("<leader>fk", "telescope.builtin", "marks", M.telescope.search_theme_name)
  M.telescope.map_n("<leader>fj", "telescope.builtin", "treesitter")
  M.telescope.map_n("<leader>fs", "telescope.builtin", "grep_string", M.telescope.search_theme_name)
  M.telescope.map_n("<leader>fg", "telescope.builtin", "live_grep", M.telescope.search_theme_name)

  M.telescope.map_n("<leader>fG", "telescope.builtin", "git_files")
  M.telescope.map_n("<leader>fo", "telescope.builtin", "git_commits", M.telescope.search_theme_name)

  M.telescope.map_n("<leader>fx", "telescope.builtin", "help_tags", M.telescope.search_theme_name)
  M.telescope.map_n("<leader>fz", "telescope.builtin", "keymaps")
  M.telescope.map_n("<leader>fy", "telescope", "extensions.neoclip.neoclip", M.telescope.search_theme_name)

  M.telescope.map_n("<leader>ft", "telescope.builtin", "diagnostics", M.telescope.search_theme_name)
end

M.telescope.lsp_key_mapping = function(bufnr)
  -- The function is called when lsp server is attached.
  M.telescope.buf_map_n(bufnr, "<c-]>", "telescope.builtin", "lsp_definitions", M.telescope.search_theme_name)

  M.telescope.buf_map_n(bufnr, "<leader>fj", "telescope.builtin", "lsp_document_symbols")
  M.telescope.buf_map_n(bufnr, "<leader>fJ", "telescope.builtin", "lsp_workspace_symbols", M.telescope.search_theme_name)

  M.telescope.buf_map_n(bufnr, "<leader>fr", "telescope.builtin", "lsp_references", M.telescope.search_theme_name)
end

M.telescope.module_arg = function(mod_name, fn_name, theme_name)
  ---@diagnostic disable-next-line: redefined-local
  local theme_name = theme_name or M.telescope.default_theme_name
  return "<cmd>lua require('" .. mod_name .. "')." .. fn_name .. "(" .. theme_name .. ")<cr>"
end

M.telescope.map_n = function(key, mod_name, fn_name, theme_name)
  ---@diagnostic disable-next-line: redefined-local
  local theme_name = theme_name or M.telescope.default_theme_name
  config_util.map_n(key, M.telescope.module_arg(mod_name, fn_name, theme_name))
end

M.telescope.buf_map_n = function(bufnr, key, mod_name, fn_name, theme_name)
  ---@diagnostic disable-next-line: redefined-local
  local theme_name = theme_name or M.telescope.default_theme_name
  config_util.buf_map_n(bufnr, key, M.telescope.module_arg(mod_name, fn_name, theme_name))
end

M.neo_tree_nvim = function()
  require("neo-tree").setup({
    close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
      indent = {
        indent_size = 2,
        padding = 1, -- extra padding on left hand side
        -- indent guides
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
        -- expander config, needed for nesting files
        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "ﰊ",
        default = "*",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
      },
      git_status = {
        symbols = {
          -- Change type
          added     = "✚",
          deleted   = "✖",
          modified  = "",
          renamed   = "",
          -- Status type
          untracked = "",
          ignored   = "",
          unstaged  = "",
          staged    = "",
          conflict  = "",
        }
      },
    },
    window = {
      position = "left",
      width = 33,
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
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_by_name = {
          ".DS_Store",
          "thumbs.db",
          "node_modules",
        },
        never_show = { -- remains hidden even if visible is toggled to true
          ".DS_Store",
          "thumbs.db",
        },
      },
      follow_current_file = true, -- This will find and focus the file in the active buffer every
                                   -- time the current file is changed while the tree is open.
      hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                                              -- in whatever position is specified in window.position
                            -- "open_current",  -- netrw disabled, opening a directory opens within the
                                              -- window like netrw would, regardless of window.position
                            -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
      use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
                                      -- instead of relying on nvim autocmd events.
    },
    buffers = {
      show_unloaded = true,
      window = {
        mappings = {
          ["bd"] = "buffer_delete",
        }
      },
    },
    git_status = {
      window = {
        position = "float",
        mappings = {
          ["A"]  = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
        }
      }
    },
  })

  config_util.map_n("<leader>fv", ":NeoTreeRevealToggle<cr>")
  config_util.map_n("<leader>fV", ":NeoTreeFocusToggle<cr>")
end

return M
