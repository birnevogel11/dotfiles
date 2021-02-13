local M = {}

function M.setup()
  require('config.lsp').setup()
  require('config.plugin').setup()
end

M.setup()
