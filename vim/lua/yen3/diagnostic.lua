local config_util = require("yen3.util.config")
local M = {}

local diagnostic_setup_buffer_enter = function()
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
end

M.diagnostic_setup = function()
  diagnostic_setup_buffer_enter()

  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  local group = vim.api.nvim_create_augroup("yen3_padding_diagnostic_virtual_text", { clear = true })
  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
      diagnostic_setup_buffer_enter()
    end,
    group = group,
  })
end

M.trouble_setup = function()
  require("trouble").setup({})
  config_util.map_n("<leader>dt", "<cmd>TroubleToggle document_diagnostics<cr>")
end

M.null_ls_setup = function()
  local null_ls = require("null-ls")
  local builtins = null_ls.builtins
  null_ls.setup({
    sources = {
      -- Python
      builtins.formatting.black.with({ extra_args = { "-l", "119" } }),

      -- Lua
      builtins.formatting.stylua.with({
        extra_args = { "--indent-type", "Spaces", "--indent-width", "2", "--column-width", "120" },
      }),

      -- Shell
      builtins.diagnostics.shellcheck,
      builtins.formatting.shfmt.with({ extra_args = { "-i", "2", "-ci" } }),

      -- Ansible
      builtins.diagnostics.ansiblelint,

      -- Dockerfile
      builtins.diagnostics.hadolint,

      -- Yaml
      builtins.diagnostics.yamllint,
    },

    -- Misc
    builtins.hover.dictionary,
  })
end

return M
