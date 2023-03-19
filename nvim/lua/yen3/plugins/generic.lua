return {
  -- Generic
  { "aymericbeaumet/vim-symlink", event = "VeryLazy" },
  { "ethanholz/nvim-lastplace",
    event = "VeryLazy",
    config = function()
      require("nvim-lastplace").setup {
        lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
        lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
        lastplace_open_folds = true
      }
    end
  },
  { "klen/nvim-config-local",
    config = function()
      require("config-local").setup({
        config_files = { ".vimrc.lua", ".vimrc", ".lvimrc", ".lvimrc.lua" },
        silent = true,
      })
    end,
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
