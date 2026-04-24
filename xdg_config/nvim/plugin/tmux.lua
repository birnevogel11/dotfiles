require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/alexghergh/nvim-tmux-navigation" },
    { src = "https://github.com/tmux-plugins/vim-tmux-focus-events" },
  }, { confirm = false })

  require("nvim-tmux-navigation").setup({
    disable_when_zoomed = false,
    keybindings = {
      left = "<C-h>",
      down = "<C-j>",
      up = "<C-k>",
      right = "<C-l>",
      last_active = "<C-\\>",
      next = "<C-Space>",
    }
  })
end)
