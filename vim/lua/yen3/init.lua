local M = {}

local opt = vim.opt

function M.preamble()
  opt.compatible = false
  vim.g.mapleader = ","
end

function M.local_setup()
  local local_vimrc = "~/.vimrc_local"
  if vim.fn.filereadable(local_vimrc) == 1 then
    vim.cmd([[ source ~/.vimrc_local ]])
  end
end

function M.setup()
  M.preamble()
  require'yen3.plugin'.setup()
  require'yen3.autocomplete_lsp'.setup()
  require'yen3.search'.setup()
  require'yen3.general'.setup()

  M.local_setup()
end

return M
