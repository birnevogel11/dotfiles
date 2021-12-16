local M = {}

function M.trouble_nvim()
  require("trouble").setup { }
  vim.api.nvim_set_keymap("n", "<leader>dt", "<cmd>TroubleToggle<cr>", {silent = true, noremap = true})
end

function M.diagnostic_symbol()
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

function M.null_ls_setup()
  local null_ls = require("null-ls")
  local builtins = null_ls.builtins
  null_ls.setup({
      sources = {
        -- Python
        builtins.formatting.black.with({
          args =  {"-l", "119", "--stdin-filename", "$FILENAME", "--quiet", "-",}
        }),

        -- Shell
        -- builtins.diagnostics.shellcheck,
      },
  })
end

function M.setup()
  M.diagnostic_symbol()
  M.trouble_nvim()
  M.null_ls_setup()
end

return M
