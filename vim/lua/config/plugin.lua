local M = {}

local config_util = require('util.config')

function M.airline()
  local vars = {
    ['airline_powerline_fonts'] = 0,
    ['airline_detect_modified'] = 1,
    ['airline_powerline_fonts'] = 0,
    ['airline_detect_modified'] = 1,
    ['airline_detect_paste'] = 1,
    ['airline_detect_iminsert'] = 0,
    ['airline#extensions#virtualenv#enabled'] = 1,
    ['airline#extensions#whitespace#enabled'] = 1,
    ['airline#extensions#branch#enabled'] = 1,
    ['airline#extensions#syntastic#enabled'] = 1,
    ['airline_theme'] = 'sunsetshiba',
    ['airline_mode_map'] = {
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
    ['ale_completion_enabled'] = 0,

    -- ['ale_set_quickfix'] = 1,

    ['ale_floating_preview'] = 1,
    ['ale_hover_to_preview'] = 1,
    ['ale_hover_to_floating_preview'] = 1,
    ['ale_detail_to_floating_preview'] = 1,
    ['ale_close_preview_on_insert'] = 0,
    ['ale_cursor_detail'] = 1,

    ['ale_lint_on_text_changed'] = 'never',
    ['ale_lint_on_insert_leave'] = 0,
    ['ale_lint_on_enter'] = 0,
    ['ale_lint_on_save'] = 1,

    ['ale_linters'] = {
      javascript = {'eslint'},
      typescript = {'prettier', 'tslint'},
      vue = {'eslint'},
      scss = {'prettier'},
      html = {'prettier'},
      reason = {'refmt'},
      python = {'pylint', 'flake8', 'mypy'},
      c = {'clang'},
      cpp = {'clang-format', 'clang', 'clangd'},
      rust = {'rustc', 'cargo', 'analyzer'},
      haskell = {'hls'},
    },

    -- Shell
    ['ale_sh_shellehck_options'] = '-e SC2086',

    -- Python
    ['ale_python_flake8_options'] = '-e E501 -e W503 -e E203',
    ['ale_python_pylint_options'] = '--max-line-length=120 -d R0201 -d W503 -d C0330',
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

  config_util.create_keymap('', '<leader>cc', '<Plug>NERDCommenterComment', {silent=true})
  config_util.create_keymap('', '<leader>cu', '<Plug>NERDCommenterUncomment', {silent=true})
  config_util.create_keymap('', '<leader>ce', '<Plug>NERDCommenterToEOL', {silent=true})
  config_util.create_keymap('', '<leader>ac', '<Plug>NERDCommenterAppend', {silent=true})
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
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    highlight = {
      enable = true,
      disable = { "c", "cpp" },
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
end

return M
