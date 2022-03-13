local config_util = require("yen3.util.config")

local M = {}

M.luatab_nvim = function()
  local luatab = require('luatab')
  local helpers = luatab.helpers

  local title = function(bufnr)
    local name = helpers.title(bufnr)
    if name ~= '[No Name]' then
      name = '[' .. name .. ']'
    end
    return name
  end

  local cell = function(index)
    local isSelected = vim.fn.tabpagenr() == index
    local buflist = vim.fn.tabpagebuflist(index)
    local winnr = vim.fn.tabpagewinnr(index)
    local bufnr = buflist[winnr]
    local hl = (isSelected and '%#TabLineSel#' or '%#TabLine#')

    return hl .. '%' .. index .. 'T' .. ' ' ..
        index .. ':' ..
        title(bufnr) .. ' ' ..
        helpers.modified(bufnr)
  end

  luatab.setup { cell = cell }
end

M.vim_better_whitespace = function()
  config_util.set_variables {
    better_whitespace_enabled = 1,
    strip_whitespace_on_save = 1,
    strip_whitelines_at_eof = 1,
    show_spaces_that_precede_tabs = 1,
    strip_whitespace_confirm = 0,
    strip_max_file_size = 1000,
  }
end

M.vim_markdown = function()
  config_util.set_variables {
    vim_markdown_folding_disabled = 1,
    vim_markdown_folding_style_pythonic = 1,
    vim_markdown_override_foldtext = 0,
    vim_markdown_new_list_item_indent = 0,
    vim_markdown_auto_insert_bullets = 1,
    vim_markdown_conceal = 0,
    vim_markdown_conceal_code_blocks = 0,
  }
end

M.tagbar = function()
  config_util.set_variables {
    tagbar_map_openfold = { "zo", "l" },
    tagbar_map_closeallfolds = "zm",
    tagbar_map_openallfolds = "zr",

    tagbar_width = 40,
    tagbar_autofocus = 1, -- Keep focus on tagbar window
    tagbar_sort = 1, -- Sort tags alphabetically
    tagbar_compact = 1,
    tagbar_indent = 1,
    tagbar_autopreview = 0, -- Don't autopreview, enable it with P
    tagbar_previewwin_pos = "belowright",

    tagbar_type_python = {
      kinds = {
        "i:modules:1:0",
        "c:classes",
        "f:functions",
        "m:members",
        "v:variables:0:0",
        "x:unknowns",
      },
    },
  }

  config_util.map_n("<leader>tb", ":TagbarOpen jc<cr>")
end

M.vim_angry_reviewer = function()
  config_util.set_variables {
    AngryReviewerEnglish = "american",
  }

  config_util.map_n("<leader>ar", ":AngryReviewer<cr>")
end

M.vim_test = function()
  config_util.set_variables {
    ["test#strategy"] = "vimux",
    ["test#python#runner"] = "pytest",
    ["test#python#pytest#options"] = {
      nearest = "-svv",
      file = "-sv",
    },
  }
  config_util.map_n("<leader>rt", ":TestNearest<cr>")
  config_util.map_n("<leader>rT", ":TestFile<cr>")
end

M.black_python = function()
  config_util.set_variables {
    black_linelength = 120,
    black_virtualenv = "~/.local/share/nvim/black",
  }
end

M.python_black_format = function()
  -- vim.cmd([[ :PyImportSortCDM ]])
  -- vim.cmd([[ :w!              ]])
  vim.cmd([[ :Black           ]])
end

M.vim_lastplace = function()
  config_util.set_variables {
    lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit",
    lastplace_ignore_buftype = "quickfix,nofile,help",
  }
end

M.local_vimrc = function()
  config_util.set_variables {
    localvimrc_sandbox = 0,
    localvimrc_persistent = 1,
  }
end

M.vim_easy_align = function()
  -- Start interactive EasyAlign in visual mode (e.g. vipga)
  vim.cmd [[ xmap ga <Plug>(EasyAlign)]]

  -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
  vim.cmd [[ nmap ga <Plug>(EasyAlign)]]
end

return M
