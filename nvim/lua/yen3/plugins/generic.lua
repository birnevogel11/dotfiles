return {
  -- Generic
  { "aymericbeaumet/vim-symlink", event = "BufRead" },
  { "ethanholz/nvim-lastplace",
    event = "BufReadPre",
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

  -- TODO: try it
  -- { "miversen33/netman.nvim", branch = "v1.1" }
}
