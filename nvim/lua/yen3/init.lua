local M = {}

local disable_builtin_plugins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "matchit",
  "matchparen",
  "tar",
  "tarPlugin",
  "rrhelper",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}

local preamble = function()
  vim.g.mapleader = ","
  vim.cmd([[ let maplocalleader = ',' ]])
end

local lazy_init_setup = function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

local lazy_setup = function()
  require("lazy").setup("yen3.plugins", {
    performance = {
      rtp = {
        disabled_plugins = disable_builtin_plugins,
      },
    },
  })
  require("yen3.lib.keymap").keymap_n("<leader>nl", "<cmd>Lazy<cr>", "Lazy")
end

local disable_watchfile_workaround = function()
  -- Disable new watch implementation until it's fixed.
  -- https://github.com/neovim/neovim/issues/23725#issuecomment-1561364086
  local ok, wf = pcall(require, "vim.lsp._watchfiles")
  if ok then
     -- disable lsp watcher. Too slow on linux
     wf._watchfunc = function()
       return function() end
     end
  end
end

M.setup = function()
  disable_watchfile_workaround()

  lazy_init_setup()
  preamble()
  require("yen3.general").setup()
  lazy_setup()
  require("yen3.diagnostic").diagnostic_setup()
  require("yen3.autocommand").setup()
end

return M
