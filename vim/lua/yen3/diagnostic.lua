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

function M.enable_diagnostic_msg_line()
  vim.cmd [[ autocmd CursorMoved * :lua require('yen3.diagnostic_msg').echo_diagnostic_or_hover() ]]
end

function M.setup()
  M.trouble_nvim()
  M.diagnostic_symbol()
end

return M
