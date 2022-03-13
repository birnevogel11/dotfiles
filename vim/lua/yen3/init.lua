local M = {}

M.preamble = function()
  vim.g.mapleader = ","
end

M.impatient = function()
  local impatient_ok, _ = pcall(require, "impatient")
  if impatient_ok then
    require("impatient").enable_profile()
  end
end

M.local_setup = function()
  local local_vimrc = vim.fn.fnamemodify("~", ":p") .. ".vimrc_local"

  if vim.fn.filereadable(local_vimrc) == 1 then
    vim.cmd("source " .. local_vimrc)
  end
end

M.setup = function()
  M.preamble()
  M.impatient()
  require('yen3.general').setup()
  require('yen3.diagnostic').diagnostic_setup()
  require('yen3.plugin').packer()

  M.local_setup()
end

return M
