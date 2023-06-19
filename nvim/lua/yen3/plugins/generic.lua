return {
  -- Generic
  { "aymericbeaumet/vim-symlink", event = "VeryLazy" },
  { "ethanholz/nvim-lastplace",
    event = "VeryLazy",
    opts = {
      lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
      lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
      lastplace_open_folds = true
    },
  },
  { "klen/nvim-config-local",
    opts = {
      config_files = { ".vimrc.lua", ".vimrc", ".lvimrc", ".lvimrc.lua" },
      silent = true,
    },
  },
  -- {
  --   "ojroques/nvim-osc52",
  --   event = "BufReadPost",
  --   cond = function()
  --     -- Check if connection is ssh
  --     return os.getenv("SSH_CLIENT") ~= nil
  --   end,
  --   config = function()
  --     local osc52 = require("osc52")
  --     vim.api.nvim_create_autocmd("TextYankPost", {
  --       pattern = "*",
  --       callback = function()
  --         if vim.v.event.operator == "y" and vim.v.event.regname == "+" then
  --           osc52.copy_register("+")
  --         end
  --       end,
  --       group = vim.api.nvim_create_augroup("OSCYank", { clear = true }),
  --     })
  --   end,
  -- },
}
