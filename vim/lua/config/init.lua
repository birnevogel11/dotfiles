local api = vim.api

local M = {}

function M.setup()
  if api.nvim_get_var("yen3_auto_complete_selection") == 1 then
    require('config.lsp').setup()
  end

  require('config.plugin').setup()
end

M.setup()
