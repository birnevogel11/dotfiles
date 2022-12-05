
local window_util = require("yen3.util.window")
local config_util = require("yen3.util.config")
local map_n = config_util.map_n
local map_call_n = config_util.map_call_n
local buf_map_call_n = config_util.buf_map_call_n

local M = {
  telescope = {},
}

M.theme_get_dropdown_opts = function()
  return {
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
end

M.theme_search_preview_opts = function()
  return {
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
end

local mod_func = function(module_name, function_name, theme_func, opt)
  theme_func = theme_func or M.default_theme
  return function()
    require(module_name)[function_name](theme_func(opt or {}))
  end
end

M.telescope_find_files = function()
  mod_func("telescope.builtin", "find_files")()
end

M.key_mapping = function()
  local telescope = require("telescope")
  local builtin = require("telescope.builtin")
  local get_visual_selection = config_util.get_visual_selection

  -- Files
  map_call_n("<leader>ff", mod_func("telescope.builtin", "find_files"),
    "Telescope: find files")
  map_call_n("<leader>fm",
    function() telescope.extensions.frecency.frecency(M.default_theme({})) end,
    "Telescope: find recently files"
  )

  -- Buffer & Mark
  map_call_n("<leader>fj", mod_func("telescope.builtin", "treesitter"), "Telescope: symbols")
  map_call_n("<leader>fb", mod_func("telescope.builtin", "buffers"), "Telescope: buffers")
  map_call_n("<leader>fk", mod_func("telescope.builtin", "marks", M.search_theme), "Telescope: marks")
  map_call_n("<leader>fy", function()
    telescope.extensions.neoclip.neoclip(M.search_theme({}))
  end, "Telescope: yanks")

  -- Grep
  map_call_n("<leader>fg", mod_func("telescope.builtin", "live_grep", M.search_theme), "Telescope: live grep")
  config_util.map_call("v", "<leader>fg", function()
    builtin.live_grep(M.search_theme({ default_text = get_visual_selection() }), "Telescope: live grep cursor word")
  end)
  map_call_n("<leader>fs", mod_func("telescope.builtin", "grep_string", M.search_theme), "Telescope: search")
  map_call_n("<leader>fG", mod_func("telescope.builtin", "current_buffer_fuzzy_find", M.search_theme), "Telescope: search current buffer")
  config_util.map_call("v", "<leader>fG", function()
    builtin.current_buffer_fuzzy_find(M.search_theme({ default_text = get_visual_selection() }), "Telescpe: search cursor word")
  end)

  -- Neovim
  map_call_n("<leader>fx", mod_func("telescope.builtin", "help_tags", M.search_theme), "Telescope: help_tags")
  map_call_n("<leader>fz", mod_func("telescope.builtin", "keymaps"), "Telescope: keymaps")
  map_call_n("<leader>fu", mod_func("telescope.builtin", "commands"), "Telescope: commands")
  map_call_n("<leader>fn", function()
    require("telescope").extensions.notify.notify(M.search_theme({}))
  end, "Telescope: notifications")

  -- Git
  map_call_n("<leader>gc", mod_func("telescope.builtin", "git_branches", M.search_theme), "Telescope: git branches")
end

-- The function is called when lsp server is attached.
M.lsp_key_mapping = function(bufnr)
  buf_map_call_n(bufnr, "<c-]>", mod_func("telescope.builtin", "lsp_definitions", M.search_theme),
    "Telescope: lsp definitions")
  buf_map_call_n(bufnr, "<leader>fj", mod_func("telescope.builtin", "lsp_document_symbols", M.default_theme),
    "Telescope: lsp symbols")
  buf_map_call_n(bufnr, "<leader>fJ", mod_func("telescope.builtin", "lsp_workspace_symbols", M.search_theme),
    "Telescope: lsp workspace symboles")
  buf_map_call_n(bufnr, "<leader>fr", mod_func("telescope.builtin", "lsp_references", M.search_theme),
    "Telescope: lsp references")
  buf_map_call_n(bufnr, "<leader>ft", mod_func("telescope.builtin", "diagnostics", M.search_theme),
    "Telescope: lsp diagnostics")
end

M.default_theme = function(opts)
  return vim.tbl_deep_extend("force", M.theme_get_dropdown_opts(), opts or {})
end

M.search_theme = function(opts)
  return vim.tbl_deep_extend("force", M.theme_search_preview_opts(), opts or {})
end

M.telescope.setup = function()
  local telescope = require("telescope")
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
  telescope.load_extension("neoclip")
  -- Haskell
  -- telescope.load_extension("hoogle")
  -- telescope.load_extension("scout")

  M.key_mapping()

  vim.api.nvim_create_autocmd(
    { "User TelescopePreviewerLoaded" },
    { command = "setlocal number relativenumber wrap list" }
  )

  require('neoclip').setup({ enable_persistent_history = true })
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
      },
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

  map_n("<leader>fv", ":NeoTreeRevealToggle<cr>", "Neotree toggle")
  map_n("<leader>fV", ":Neotree float<cr>", "Neotree float")
end

return M
