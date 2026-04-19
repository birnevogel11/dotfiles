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

}
