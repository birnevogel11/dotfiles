local M = {}

function M.trouble_nvim_keymapping()
  -- require("trouble").setup({})
  vim.api.nvim_set_keymap("n", "<leader>dt", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
end

function M.diagnostic_setup()
  vim.diagnostic.config({
    underline = true,
    signs = true,
    update_in_insert = false,
    virtual_text = {
      prefix = "",
      format = function(diagnostic)
        -- Show diagnostic messages after coloum 80
        -- Ref: https://gist.github.com/tjdevries/ccbe3b79bd918208f2fa8dfe15b95793
        local line_space = 75 -- 80 - 5 (original space (6) - 1)

        local bufnr = diagnostic.bufnr
        local line = diagnostic.lnum
        local line_length = #(vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1] or "")
        local msg = "■ " .. diagnostic.message
        if line_length < line_space then
          msg = string.rep(" ", line_space - line_length) .. msg
        end
        return msg
      end,
    },
  })

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
      -- builtins.formatting.isort.with({ extra_args = { "-l", "119" } }),
      builtins.formatting.black.with({ extra_args = { "-l", "119" } }),

      -- Lua
      builtins.formatting.stylua.with({
        extra_args = { "--indent-type", "Spaces", "--indent-width", "2", "--column-width", "120" },
      }),

      -- Shell
      builtins.diagnostics.shellcheck,
      builtins.formatting.shfmt.with({ extra_args = { "-i", "2", "-ci" } }),
    },

    -- Misc
    builtins.hover.dictionary,
  })
end

function M.setup()
  M.diagnostic_setup()
  M.trouble_nvim_keymapping()
  M.null_ls_setup()
end

return M
