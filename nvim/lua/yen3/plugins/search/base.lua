local lib_win = require("yen3.lib.window")

local keymap = require("yen3.lib.keymap").keymap
local keymap_n = require("yen3.lib.keymap").keymap_n

local M = {
  telescope = {},
}

local get_visual_selection = function()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})

  ---@diagnostic disable-next-line: param-type-mismatch
  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

local mod_func = function(module_name, function_name, theme_func, opt)
  theme_func = theme_func or M.default_theme
  return function()
    require(module_name)[function_name](theme_func(opt or {}))
  end
end

M.theme_get_dropdown_opts = function()
  local previewer = false
  -- if lib_win.enable_preview() then
  --   previewer = require('telescope.previewers').cat.new
  -- end
  return {
    theme = "dropdown_mini",
    sorting_strategy = "ascending",
    layout_strategy = "center",
    prompt_prefix = "λ ",
    prompt_title = "",
    preview_title = "",
    results_title = false,
    previewer = previewer,
    layout_config = {
      width = lib_win.get_float_window_width(),
      height = lib_win.get_float_window_height(),
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
      width = lib_win.get_float_window_width(),
      height = lib_win.get_float_window_height(30),
      prompt_position = "bottom",
      preview_height = 15,
    },
    border = true,
  }
end

M.telescope_find_files = function()
  mod_func("telescope.builtin", "find_files")()
end

M.key_mapping = function()
  local telescope = require("telescope")
  local builtin = require("telescope.builtin")

  -- Files
  keymap_n("<leader>ff", mod_func("telescope.builtin", "find_files"), "Telescope: find files")
  keymap_n("<leader>fm", function()
    telescope.extensions.frecency.frecency(M.default_theme({}))
  end, "Telescope: find recently files")
  keymap_n("<leader>fc", function()
    require("telescope").extensions.file_browser.file_browser(M.default_theme({}))
  end)

  -- Buffer & Mark
  keymap_n("<leader>fj", mod_func("telescope.builtin", "treesitter"), "Telescope: symbols")
  keymap_n("<leader>fB", mod_func("telescope.builtin", "buffers"), "Telescope: buffers")
  keymap_n("<leader>fk", mod_func("telescope.builtin", "marks", M.search_theme), "Telescope: marks")
  -- keymap_n("<leader>fy", function()
  --   telescope.extensions.neoclip.neoclip(M.search_theme({}))
  -- end, "Telescope: yanks")

  -- Jump dir/files
  keymap_n("<leader>fd", function()
    require("yen3.plugins.search.dirs").telescope_z_custom(M.theme_get_dropdown_opts())
  end, "Telescope: change cwd")
  keymap_n("<leader>fdd", function()
    require("yen3.plugins.search.dirs").jump_back_init_cwd()
  end, "Telescope: change cwd to the initial dir")

  -- Grep
  keymap_n(
    "<leader>fb",
    mod_func("telescope.builtin", "current_buffer_fuzzy_find", M.search_theme),
    "Telescope: search current buffer"
  )
  keymap("v", "<leader>fb", function()
    builtin.current_buffer_fuzzy_find(
      M.search_theme({ default_text = get_visual_selection() }),
      "Telescope: search current buffer with cursor word"
    )
  end)

  keymap_n("<leader>fg", function()
    require("telescope").extensions.live_grep_args.live_grep_args(M.search_theme({}))
  end)
  keymap("v", "<leader>fg", function()
    require("telescope").extensions.live_grep_args.live_grep_args(
      M.search_theme({ default_text = get_visual_selection() })
    )
  end)
  keymap_n("<leader>fs", mod_func("telescope.builtin", "grep_string", M.search_theme), "Telescope: search")

  -- Neovim
  keymap_n("<leader>fx", mod_func("telescope.builtin", "help_tags", M.search_theme), "Telescope: help_tags")
  keymap_n("<leader>fz", mod_func("telescope.builtin", "keymaps"), "Telescope: keymaps")
  keymap_n("<leader>fe", mod_func("telescope.builtin", "commands"), "Telescope: commands")

  -- Custom commands
  -- keymap_n("<leader>fu", function()
  --   telescope.extensions.menu.menu(M.default_theme({}))
  -- end, "Telescope: custom commands")
  keymap_n("<leader>cc", function()
    telescope.extensions.menu.octo(require("telescope.themes").get_cursor({}))
  end, "Telescope: octo commands")

  -- List notification history
  keymap_n("<leader>fn", function()
    require("telescope").extensions.notify.notify(M.search_theme({}))
  end, "Telescope: notifications")

  -- Git
  keymap_n("<leader>gc", mod_func("telescope.builtin", "git_branches", M.search_theme), "Telescope: git branches")

  keymap_n("<leader>fo", function()
    vim.cmd("DevdocsOpen python-3.11")
  end)
end

-- The function is called when lsp server is attached.
M.lsp_key_mapping = function(bufnr)
  local nmap = function(lhs, rhs, desc)
    keymap_n(lhs, rhs, desc, bufnr)
  end

  nmap("<c-]>", mod_func("telescope.builtin", "lsp_definitions", M.search_theme), "Telescope: lsp definitions")
  nmap("<leader>fj", mod_func("telescope.builtin", "lsp_document_symbols", M.default_theme, { symbol_width = 60 }), "Telescope: lsp symbols" )
  nmap(
    "<leader>fjj",
    mod_func("telescope.builtin", "lsp_workspace_symbols", M.search_theme, { symbol_width = 60 }),
    "Telescope: lsp workspace symboles"
  )
  nmap("<leader>fr", mod_func("telescope.builtin", "lsp_references", M.search_theme), "Telescope: lsp references")
  nmap("<leader>ft", mod_func("telescope.builtin", "diagnostics", M.search_theme), "Telescope: lsp diagnostics")
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
    create_layout = require("yen3.plugins.search.layout").create_layout,
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
      -- hoogle = {
      --   render = 'default',
      --   renders = {
      --     treesitter = {
      --       remove_wrap = false
      --
      --     }
      --   }
      -- },
      menu = require("yen3.plugins.search.menu"),
      -- ["ui-select"] = {
      --   require("telescope.themes").get_dropdown { }
      -- }
    },
  })

  telescope.load_extension("fzf")
  telescope.load_extension("frecency")
  telescope.load_extension("menu")
  telescope.load_extension("live_grep_args")
  telescope.load_extension("file_browser")
  -- telescope.load_extension("ui-select")
  -- telescope.load_extension("gh")
  -- telescope.load_extension("neoclip")
  -- require("neoclip").setup({ enable_persistent_history = true })

  vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopePreviewerLoaded",
    callback = function(_)
      vim.wo.number = true
      vim.wo.relativenumber = true
      vim.wo.wrap = true
    end,
  })

  M.key_mapping()

  require("nvim-devdocs").setup()
end

return M
