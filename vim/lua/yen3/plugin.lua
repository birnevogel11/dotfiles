local M = {}
M.git = {} -- git

local config_util = require('util.config')

function M.airline()
  config_util.set_variables {
    airline_detect_modified = 1,
    airline_powerline_fonts = 0,
    airline_detect_paste = 1,
    airline_detect_iminsert = 0,
    airline_theme = 'sunsetshiba',
    ['airline#extensions#virtualenv#enabled'] = 1,
    ['airline#extensions#whitespace#enabled'] = 1,
    ['airline#extensions#branch#enabled'] = 1,
    ['airline#extensions#syntastic#enabled'] = 1,
    airline_mode_map = {
       ['__'] = '-',
       ['n'] = 'N',
       ['i'] = 'I',
       ['R'] = 'R',
       ['c'] = 'C',
       ['v'] = 'V',
       ['V'] = 'V',
       [''] = 'V',
       ['s'] = 'S',
       ['S'] = 'S',
       [''] = 'S'
      }
  }
end

function M.ale()
  config_util.set_variables {
    ale_completion_enabled = 0,
    ale_set_quickfix = 1,
    -- ale_virtualtext_cursor = 1,
    ale_lint_on_text_changed = 'never',
    ale_lint_on_insert_leave = 0,
    ale_lint_on_enter = 0,
    ale_lint_on_save = 1,

    ale_linters = {
      python = {'pylint', 'flake8', 'mypy'},
      -- vim = {'vint'},
      -- javascript = {'eslint', 'prettier'},
      -- typescript = {'prettier', 'tslint'},
      -- vue = {'eslint'},
      -- scss = {'prettier'},
      -- html = {'prettier'},
      -- c = {'clang'},
      -- cpp = {'clang-format', 'clang', 'clangd'},
      -- rust = {'rustc', 'cargo', 'analyzer'},
      -- reason = {'refmt'},
    },

    -- Shell
    ale_sh_shellehck_options = '-e SC2086',

    -- Python
    ale_python_flake8_options = '-e E501 -e W503 -e E203',
    ale_python_pylint_options = '--max-line-length=120 -d R0201 -d W503 -d C0330',
  }
end

function M.nerd_commenter()
  config_util.set_variables {
    NERDSpaceDelims = 1,  -- Leave space after comment delimiter
    NERDCreateDefaultMappings = 0,  -- Disable default mappings
    NERDCustomDelimiters = { python = { left = '#' } }, -- Fix python spacing
  }

  local keymap = function(leader_key, value)
    config_util.create_keymap('', '<leader>'..leader_key, '<Plug>'..value, {silent=true})
  end

  keymap('cc', 'NERDCommenterComment')
  keymap('cu', 'NERDCommenterUncomment')
  keymap('ce', 'NERDCommenterToEOL')
  keymap('ac', 'NERDCommenterAppend')
end

function M.vim_markdown()
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

function M.vim_localvimrc()
  config_util.set_variables { localvimrc_ask = 0, }
end

function M.indentline()
  config_util.set_variables {
    indentLine_char = '│',
    indentLine_faster = 1
  }
end

function M.spelunker()
  config_util.set_variables { enable_spelunker_vim = 0, }
end

function M.nvim_treesitter()
  local ignore_install_lang = {}
  local disable_lang = {"yaml"}

  if vim.fn.has("mac") == 1 then
    require'nvim-treesitter.install'.compilers = { "gcc-11" }
    table.insert(disable_lang, "dockerfile")
  elseif vim.fn.has("unix") == 1 then
    require'nvim-treesitter.install'.compilers = { "clang-12" }
  end

  require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    ignore_install = ignore_install_lang,
    highlight = {
      enable = true,
      disable = disable_lang,
    },
  }
end

function M.restoreview_vim()
  config_util.set_variables {
    viewoptions = "cursor,folds,slash,unix",
    foldmethod = "indent",
    foldnestmax = 10,
    foldenable = false,
    foldlevel = 2,
  }
end

function M.train_nvim()
  config_util.map_n('<leader>jj', ':TrainTextObj<cr>')
end

function M.tagbar()
  config_util.set_variables {
    tagbar_map_openfold = {'zo', 'l'},
    tagbar_map_closeallfolds = 'zm',
    tagbar_map_openallfolds = 'zr',

    tagbar_width = 40,
    tagbar_autofocus = 1,                 -- Keep focus on tagbar window
    tagbar_sort = 1,                      -- Sort tags alphabetically
    tagbar_compact = 1,
    tagbar_indent = 1,
    tagbar_autopreview = 0,               -- Don't autopreview, enable it with P
    tagbar_previewwin_pos = 'belowright',

    tagbar_type_python = {
      kinds = {
        'i:modules:1:0',
        'c:classes',
        'f:functions',
        'm:members',
        'v:variables:0:0',
        'x:unknowns',
      },
    },
  }

  config_util.map_n('<leader>tb', ':TagbarOpen jc<cr>')
end

function M.vim_test()
  config_util.set_variables {
   ['test#strategy'] = "vimux",
   ['test#python#runner'] = 'nose',
   ['test#python#nose#options'] = { nearest = '-sv --config /dev/null' },
  }
  config_util.map_n('<leader>rt', ':TestNearest')
  config_util.map_n('<leader>rT', ':TestFile')
end

function M.vim_cpp_enhanced_highlight()
  config_util.set_variables {
    load_doxygen_syntax = 1,
    cpp_class_scope_highlight = 1,
  }
end

function M.python_black()
  config_util.set_variables {
    black_linelength = 120,
    black_virtualenv = "~/.local/share/nvim/black",
  }
end

function M.clang_format()
  config_util.set_variables { ['clang_format#detect_style_file'] = 1, }
end

function M.nvim_mini_yank()
  vim.cmd([[ map p <Plug>(miniyank-autoput) ]])
  vim.cmd([[ map P <Plug>(miniyank-autoPut) ]])
end

function M.git.twiggy()
  config_util.set_variables {
    twiggy_group_locals_by_slash = 0,
    twiggy_local_branch_sort = 'mru',
    twiggy_remote_branch_sort = 'date',
  }

  config_util.map_n('<leader>gB', ":Twiggy<cr>")
  -- ref: https://github.com/sodapopcan/vim-twiggy/issues/30
  vim.cmd([[ autocmd VimEnter * if empty(expand('<amatch>'))|call FugitiveDetect(getcwd())|endif ]])
end

function M.enable_spelunker(...)
  local words = {}
  for _, path in pairs({...}) do
    for _, local_word in pairs(vim.fn.readfile(path)) do
      table.insert(words, local_word)
    end
  end

  config_util.set_variables {
    enable_spelunker_vim = 1,
    spelunker_white_list_for_user = words,
  }
end

function M.python_black_format()
  if vim.fn.system("black --version") == "black, version 19.10b0\n" then
    vim.cmd([[ :w!                               ]])
    vim.cmd([[ :PyImportSortCDM                  ]])
    vim.cmd([[ :w!                               ]])
    vim.cmd([[ :silent exec "!black -l 119 -q %" ]])
    vim.cmd([[ :e!                               ]])
  else
    vim.cmd([[ :PyImportSortCDM ]])
    vim.cmd([[ :Black           ]])
  end
end

function M.git.fugitive_git_command()
  local cmd_args = vim.fn.input('git ')
  vim.fn.execute("Git " .. cmd_args)
end

function M.git.fugitive_git_pull_master()
  local current_branch = vim.fn.system('git branch --show-current')

  vim.fn.execute('silent !git checkout master')
  vim.fn.execute('silent !git pull')
  vim.fn.execute('silent !git checkout ' .. current_branch)
end

function M.git.fugitive_git_rebase_origin_master()
  vim.fn.execute('silent !git fetch origin master')
  vim.fn.execute(':Git rebase -i origin/master')
end

function M.git.neogit()
  require'neogit'.setup {
    integrations = {
      diffview = true,
    },
  }

  config_util.map_n("<leader>gn", ":Neogit<cr>")
end

function M.git.fugitive_gina()
  local map_n = config_util.map_n
  map_n('<leader>g', ":lua require('yen3.plugin').git.fugitive_git_command()")

  map_n('<leader>gc', ":Git checkout ")

  map_n("<leader>gs", ":vertical topleft Git<cr>")

  map_n("<leader>gA", ":Git add --patch<cr>")

  map_n("<leader>gd", ":Git diff<cr>")
  map_n("<leader>gdd", ":Gvdiffsplit!<cr>")

  map_n("<leader>gb", ":Git blame<cr>")
  map_n("<leader>gB", ":Gina blame<cr>")

  map_n("<leader>gp", ":Git push<cr>")
  map_n("<leader>gpp", ":Gina! push origin HEAD:refs/for/master<cr>")

  map_n("<leader>gP", ":Dispatch! Git pull<cr>")
  map_n("<leader>gpm", ":lua require('yen3.plugin').git.fugitive_git_pull_master()<cr>")

  map_n("<leader>gr", ":Git rebase -i origin/master<cr>")
  map_n("<leader>grr", ":lua require('yen3.plugin').git.fugitive_git_rebase_origin_master<cr>")
  map_n("<leader>gri", ":Git rebase -i")
end

function M.gitsigns()
  require('gitsigns').setup()
end

function M.git.diff_view()
  require'diffview'.setup {
    file_panel = {
      width = 20,
      use_icons = false
    },
  }
end

function M.setup()
  M.nvim_treesitter()
  M.airline()
  M.ale()
  M.nerd_commenter()
  M.vim_markdown()
  M.vim_localvimrc()
  M.indentline()
  M.spelunker()
  M.restoreview_vim()
  M.train_nvim()
  M.tagbar()
  M.gitsigns()
  M.vim_cpp_enhanced_highlight()
  M.python_black()
  M.clang_format()
  M.nvim_mini_yank()

  M.git.fugitive_gina()
  M.git.twiggy()
  M.git.neogit()
  M.git.diff_view()

  vim.cmd([[ source ~/.config/nvim/vim/plugin.vim ]])
end

return M
