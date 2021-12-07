local M = {}
local config_util = require('util.config')

function M.ale()
  config_util.set_variables {
    ale_completion_enabled = 0,
    ale_set_quickfix = 1,
    -- ale_virtualtext_cursor = 1,
    ale_lint_on_text_changed = 'never',
    ale_lint_on_insert_leave = 0,
    ale_lint_on_enter = 0,
    ale_lint_on_save = 1,

    ale_sign_error = ' ',
    ale_sign_warning = ' ',

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

function M.trouble_nvim()
  require("trouble").setup { }
  vim.api.nvim_set_keymap("n", "<leader>dt", "<cmd>TroubleToggle<cr>", {silent = true, noremap = true})

  local function lspSymbol(name, icon)
  vim.fn.sign_define(
    'DiagnosticSign' .. name,
    { text = icon, numhl = 'DiagnosticDefault' .. name }
  )
  end

  lspSymbol('Error', '')
  lspSymbol('Hint', '')
  lspSymbol('Info', '')
  lspSymbol('Warn', '')
end

function M.setup()
  -- M.ale()
  M.trouble_nvim()
end

return M
