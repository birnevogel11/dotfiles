local lib_win = require("bv11.lib.window")

local keymap = require("bv11.lib.keymap").keymap
local keymap_n = require("bv11.lib.keymap").keymap_n

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

local mk_mod_func = function(module_name, function_name, theme_func, opt)
  theme_func = theme_func or M.default_theme

  local func = require(module_name)
  for _, name in ipairs(vim.split(function_name, ".", { plain = true, trimempty = true })) do
    func = func[name]
  end

  return function(custom_opt)
    func(theme_func(custom_opt or opt or {}))
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
  mk_mod_func("telescope.builtin", "find_files")()
end

M.key_mapping = function()
  -- Telescope
  -- keymap_n(
  --   "<leader>fr",
  --   mk_mod_func("telescope.builtin", "resume", M.search_theme),
  --   "Telescope: resume previous picker"
  -- )

  -- Files
  -- keymap_n("<leader>ff", mk_mod_func("telescope.builtin", "find_files"), "Telescope: find files")
  -- keymap_n("<leader>fn", mk_mod_func("telescope.builtin", "git_status", M.search_theme), "Telescope: git status")
  -- keymap_n("<leader>fm", mk_mod_func("telescope", "extensions.bv11_jumper.files"), "Telescope: find recently files")
  -- keymap_n("<leader>fc", mk_mod_func("telescope", "extensions.file_browser.file_browser"), "Telescope: file browser")

  -- Buffer & Mark
  -- keymap_n("<leader>fj", mk_mod_func("telescope.builtin", "treesitter"), "Telescope: symbols")
  -- keymap_n("<leader>fb", mk_mod_func("telescope.builtin", "buffers"), "Telescope: buffers")
  -- keymap_n("<leader>fk", mk_mod_func("telescope.builtin", "marks", M.search_theme), "Telescope: marks")
  -- keymap_n("<leader>fy", mk_mod_func("telescope", "extensions.neoclip.neoclip", M.search_theme), "Telescope: yanks")

  -- Jump dir/files
  -- keymap_n("<leader>fd", mk_mod_func("telescope", "extensions.bv11_jumper.dirs"), "Telescope: change cwd")
  -- keymap_n("<leader>fdd", function()
  --   require("telescope-bv11-jumper.dirs").jump_back_init_cwd()
  -- end, "Telescope: change cwd to the initial dir")

  -- Grep
  -- keymap_n(
  --   "<leader>fw",
  --   mk_mod_func("telescope.builtin", "current_buffer_fuzzy_find", M.search_theme),
  --   "Telescope: search current buffer"
  -- )
  -- keymap("v", "<leader>fw", function()
  --   mk_mod_func("telescope.builtin", "current_buffer_fuzzy_find", M.search_theme)({
  --     default_text = get_visual_selection(),
  --   })
  -- end, "Telescope: search current buffer with cursor word")

  -- keymap_n("<leader>fg", mk_mod_func("telescope", "extensions.live_grep_args.live_grep_args", M.search_theme))
  -- keymap("v", "<leader>fg", function()
  --   mk_mod_func("telescope", "extensions.live_grep_args.live_grep_args", M.search_theme)({
  --     default_text = get_visual_selection(),
  --   })
  -- end, "Telescope: search with cursor word")
  -- keymap_n("<leader>fs", mk_mod_func("telescope.builtin", "grep_string", M.search_theme), "Telescope: search")

  -- Neovim
  -- keymap_n("<leader>fx", mk_mod_func("telescope.builtin", "help_tags", M.search_theme), "Telescope: help_tags")
  -- keymap_n("<leader>fz", mk_mod_func("telescope.builtin", "keymaps"), "Telescope: keymaps")
  -- keymap_n("<leader>fe", mk_mod_func("telescope.builtin", "commands"), "Telescope: commands")

  -- Custom commands
  -- keymap_n("<leader>fu", function()
  --   telescope.extensions.menu.menu(M.default_theme({}))
  -- end, "Telescope: custom commands")
  -- keymap_n(
  --   "<leader>cc",
  --   mk_mod_func("telescope", "extensions.menu.octo", require("telescope.themes").get_cursor),
  --   "Telescope: octo commands"
  -- )

  -- List notification history
  -- keymap_n(
  --   "<leader>fn",
  --   mk_mod_func("telescope", "extensions.notify.notify", M.search_theme),
  --   "Telescope: notifications"
  -- )

  -- Git
  -- keymap_n("<leader>gc", mk_mod_func("telescope.builtin", "git_branches", M.search_theme), "Telescope: git branches")

  -- keymap_n("<leader>fo", function()
  --   vim.cmd("DevdocsOpen python-3.11")
  -- end)

  -- M.zuul_key_mapping()
end

M.zuul_key_mapping = function()
  local zuul_map = function(key, func_name, description, select_with_job_name)
    keymap_n(
      "<leader>" .. key,
      mk_mod_func("telescope", "extensions.zuul_search." .. func_name, M.search_theme),
      "Telescope: " .. description
    )
    if select_with_job_name then
      keymap("v", "<leader>" .. key, function()
        mk_mod_func("telescope", "extensions.zuul_search." .. func_name, M.search_theme)({
          job_name = get_visual_selection(),
        })
      end, "Telescope: " .. description .. " with visual selection")
    else
      keymap("v", "<leader>" .. key, function()
        mk_mod_func("telescope", "extensions.zuul_search." .. func_name, M.search_theme)({
          default_text = get_visual_selection(),
        })
      end, "Telescope: " .. description .. " with visual selection")
    end
  end

  -- Zuul
  zuul_map("zj", "jobs", "zuul jobs")
  zuul_map("zw", "workdir_vars", "zuul workdir vars")
  zuul_map("zr", "roles", "zuul roles")
  zuul_map("zt", "project_templates", "zuul project templates")
  zuul_map("zv", "job_vars", "zuul job vars", true)
  zuul_map("zh", "job_hierarhcy", "zuul job hierarchy", true)
  zuul_map("zp", "job_playbooks", "zuul job_playbooks ", true)
end

-- The function is called when lsp server is attached.
M.lsp_key_mapping = function(bufnr)
  local nmap = function(lhs, rhs, desc)
    keymap_n(lhs, rhs, desc, bufnr)
  end

  -- nmap("<c-]>", mk_mod_func("telescope.builtin", "lsp_definitions", M.search_theme), "Telescope: lsp definitions")
  -- nmap(
  --   "<leader>fj",
  --   mk_mod_func("telescope.builtin", "lsp_document_symbols", M.default_theme, { symbol_width = 60 }),
  --   "Telescope: lsp symbols"
  -- )
  -- nmap(
  --   "<leader>fk",
  --   mk_mod_func("telescope.builtin", "lsp_workspace_symbols", M.search_theme, { symbol_width = 60 }),
  --   "Telescope: lsp workspace symboles"
  -- )
  -- nmap("<leader>fl", mk_mod_func("telescope.builtin", "lsp_references", M.search_theme), "Telescope: lsp references")
  -- nmap("<leader>ft", mk_mod_func("telescope.builtin", "diagnostics", M.search_theme), "Telescope: lsp diagnostics")
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
      menu = require("bv11.plugins.search.menu"),
      -- ["ui-select"] = {
      --   require("telescope.themes").get_dropdown { }
      -- }
    },
  })

  telescope.load_extension("fzf")
  telescope.load_extension("menu")
  telescope.load_extension("live_grep_args")
  telescope.load_extension("file_browser")

  -- Personal plugins
  telescope.load_extension("zuul_search")
  telescope.load_extension("bv11_jumper")

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

  -- require("nvim-devdocs").setup()
end

return M
