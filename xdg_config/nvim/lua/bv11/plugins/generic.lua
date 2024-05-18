return {
  -- Generic
  { "aymericbeaumet/vim-symlink", event = "VeryLazy" },
  {
    "ethanholz/nvim-lastplace",
    event = "VeryLazy",
    opts = {
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
      lastplace_open_folds = true,
    },
  },
  {
    "klen/nvim-config-local",
    opts = {
      config_files = { ".vimrc.lua", ".vimrc", ".lvimrc", ".lvimrc.lua" },
      silent = true,
    },
  },

  -- Enable it when https://github.com/mobile-shell/mosh/pull/1054 is merged.
  -- {
  --   "ojroques/nvim-osc52",
  --   event = "BufReadPost",
  --   cond = function()
  --     -- Check if connection is ssh
  --     return os.getenv("SSH_CLIENT") ~= nil
  --   end,
  --   config = function()
  --     vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
  --     vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
  --     vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)
  --   end,
  -- },
}
