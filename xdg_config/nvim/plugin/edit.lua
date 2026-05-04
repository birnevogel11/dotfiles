require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    -- TODO: Check them
    -- { src = "https://github.com/tpope/vim-rhubarb" },
    -- { src = "https://github.com/tpope/vim-speeddating" },
    -- { src = "https://github.com/tpope/vim-surround" },
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/godlygeek/tabular" },
    -- { src = "https://github.com/RRethy/nvim-treesitter-endwise" },
  }, { confirm = false })

  require("nvim-autopairs").setup()
end)

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/cappyzawa/trim.nvim" },
  }, { confirm = false })

  require("trim").setup({
    ft_blocklist = { "TelescopePrompt", "Trouble", "help" },
    trim_on_write = true,
    trim_trailing = true,
    trim_last_line = true,
    trim_first_line = false,
  })

  -- Set traiing space highlight
  vim.fn.matchadd("TrimSpace", "\\s\\+$")
end)

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/junegunn/vim-easy-align" },
  }, { confirm = false })

  -- Start interactive EasyAlign in visual mode (e.g. vipga)
  vim.cmd([[ xmap ga <Plug>(EasyAlign)]])

  -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
  vim.cmd([[ nmap ga <Plug>(EasyAlign)]])
end)

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/max397574/better-escape.nvim" },
  }, { confirm = false })

  require("better_escape").setup({ timeout = 300 })
end)

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/aymericbeaumet/vim-symlink" },
  }, { confirm = false })
end)

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/ethanholz/nvim-lastplace" },
  }, { confirm = false })

  require("nvim-lastplace").setup({
    lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
    lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
    lastplace_open_folds = true,
  })
end)

-- require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/klen/nvim-config-local" },
  }, { confirm = false })

  require("config-local").setup({
    config_files = { ".vimrc.lua", ".vimrc", ".lvimrc", ".lvimrc.lua" },
    silent = true,
  })
-- end)
