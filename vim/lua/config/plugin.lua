local M = {}

local config_util = require('util.config')

function M.airline()
  local vars = {
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

  config_util.set_variables(vars)
end

function M.ale()
  local vars = {
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

  config_util.set_variables(vars)
end

function M.nerd_commenter()
  local vars = {
    -- Leave space after comment delimiter
    NERDSpaceDelims = 1,
    -- Disable default mappings
    NERDCreateDefaultMappings = 0,
    -- Fix python spacing
    NERDCustomDelimiters = { python = { left = '#' } }
  }
  config_util.set_variables(vars)

  local keymap = function(leader_key, value)
    config_util.create_keymap('', '<leader>'..leader_key, '<Plug>'..value, {silent=true})
  end

  keymap('cc', 'NERDCommenterComment')
  keymap('cu', 'NERDCommenterUncomment')
  keymap('ce', 'NERDCommenterToEOL')
  keymap('ac', 'NERDCommenterAppend')
end

function M.vim_markdown()
  local vars = {
    vim_markdown_folding_disabled = 1,
    vim_markdown_folding_style_pythonic = 1,
    vim_markdown_override_foldtext = 0,
    vim_markdown_new_list_item_indent = 0,
    vim_markdown_auto_insert_bullets = 1,
    vim_markdown_conceal = 0,
    vim_markdown_conceal_code_blocks = 0,
  }

  config_util.set_variables(vars)
end

function M.vim_localvimrc()
  config_util.set_variables({ localvimrc_ask = 0, })
end

function M.indentline()
  local vars = {
    indentLine_char = '│',
    indentLine_faster = 1
  }

  config_util.set_variables(vars)
end

function M.spelunker()
  config_util.set_variables({ enable_spelunker_vim = 0, })
end

function M.nvim_treesitter()
  local ignore_install_lang = {}
  local disable_lang = {"yaml"}

  if vim.fn.has("mac") == 1 then
    require'nvim-treesitter.install'.compilers = { "gcc-11" }

    table.insert(ignore_install_lang, "python")
    table.insert(disable_lang, "python")
    table.insert(disable_lang, "dockerfile")
    table.insert(disable_lang, "lua")
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
  local options = {
    viewoptions = "cursor,folds,slash,unix",
    foldmethod = "indent",
    foldnestmax = 10,
    foldenable = false,
    foldlevel = 2,
  }

  config_util.set_options(options)
end

function M.train_nvim()
  config_util.create_keymap('n', '<leader>jj', ':TrainTextObj<cr>')
end

function M.setup()
  M.airline()
  M.ale()
  M.nerd_commenter()
  M.vim_markdown()
  M.vim_localvimrc()
  M.indentline()
  M.spelunker()
  M.nvim_treesitter()
  M.restoreview_vim()
  M.train_nvim()
end

return M
