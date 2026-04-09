local M = {}

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
  require("lazy").setup("bv11.plugins", {
    performance = {
      rtp = {
        disabled_plugins = {
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
        },
      },
    },
  })

  -- vim.pack.add(
  --   {"nvim.undotree"}, { load = function()
  --     vim.keymap.set("n", "<leader>du", vim.cmd.Undotree, { desc = "Toggle undotree" })
  --   end }
  -- )
  vim.cmd([[ packadd nvim.undotree ]])
  vim.keymap.set("n", "<leader>u", vim.cmd.Undotree, { desc = "Toggle undotree" })

  vim.cmd([[ packadd nvim.difftool ]])
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
  -- Colorscheme config
  require("bv11.sunsetshiba").setup()

  disable_watchfile_workaround()

  lazy_init_setup()
  preamble()
  require("bv11.general").setup()
  lazy_setup()
  require("bv11.diagnostic").diagnostic_setup()
  require("bv11.autocommand").setup()
  require("bv11.treesitter").setup()
end

return M
