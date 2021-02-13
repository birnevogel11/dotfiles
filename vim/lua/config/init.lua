local M = {}

local opt = vim.api.nvim_set_option
local cmd = vim.api.nvim_command
local map = vim.api.nvim_set_keymap
local exec = vim.api.nvim_exec
local g_set_var = vim.api.nvim_set_var

function map_s(mode, key, value)
  map(mode, key, value, { noremap = true, silent = true })
end

function M.airline()
  g_set_var('airline_powerline_fonts', 0)
  g_set_var('airline_detect_modified', 1)
  g_set_var('airline_powerline_fonts', 0)
  g_set_var('airline_detect_modified', 1)
  g_set_var('airline_detect_paste', 1)
  g_set_var('airline_detect_iminsert', 0)
  g_set_var('airline#extensions#virtualenv#enabled', 1)
  g_set_var('airline#extensions#whitespace#enabled', 1)
  g_set_var('airline#extensions#branch#enabled', 1)
  g_set_var('airline#extensions#syntastic#enabled', 1)
  g_set_var('airline_theme', 'sunsetshiba')
  g_set_var('airline_mode_map', {
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
  )
end

function M.ale()
  g_set_var('ale_completion_enabled', 0)

  g_set_var('ale_set_quickfix', 1)

  g_set_var('ale_lint_on_text_changed', 'never')
  g_set_var('ale_lint_on_insert_leave', 0)
  g_set_var('ale_lint_on_enter', 0)
  g_set_var('ale_lint_on_save', 1)

  g_set_var('ale_linters', {
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
  })

  -- Shell
  g_set_var('ale_sh_shellehck_options', '-e SC2086')

  -- Python
  g_set_var('ale_python_flake8_options',
            '-e E501 -e W503 -e E203')
  g_set_var('ale_python_pylint_options',
            '--max-line-length=120 -d R0201 -d W503 -d C0330')
end

function M.setup()
  M.airline()
  M.ale()

  require('config.lsp').setup()
end

M.setup()

return M
