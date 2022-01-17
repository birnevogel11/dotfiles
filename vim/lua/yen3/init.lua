local M = {}

function M.preamble()
  vim.g.mapleader = ","
end

function M.local_setup()
  local local_vimrc = vim.fn.fnamemodify("~", ":p") .. ".vimrc_local"

  if vim.fn.filereadable(local_vimrc) == 1 then
    vim.cmd("source " .. local_vimrc)
  end
end

function M.setup()
  M.preamble()
  require('yen3.plugin').setup()
  require('yen3.general').setup()

  M.local_setup()
end

return M
