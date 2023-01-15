local M = {}

local preamble = function()
  vim.g.mapleader = ","
  vim.cmd [[ let maplocalleader = ',' ]]
end

local lazy_init_setup = function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
    })
  end
  vim.opt.runtimepath:prepend(lazypath)
end

M.setup = function()
  lazy_init_setup()
  preamble()
  require("yen3.general").setup()
  require("yen3.lazy").setup()
  require("yen3.diagnostic").diagnostic_setup()
end

return M
