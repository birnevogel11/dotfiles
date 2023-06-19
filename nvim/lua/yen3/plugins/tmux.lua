return {
  { "alexghergh/nvim-tmux-navigation",
    opts = {
      disable_when_zoomed = false,
      keybindings = {
        left = "<C-h>",
        down = "<C-j>",
        up = "<C-k>",
        right = "<C-l>",
        last_active = "<C-\\>",
        next = "<C-Space>",
      },
    },
    event = "VeryLazy"
  },

  { "tmux-plugins/vim-tmux-focus-events", event = "VeryLazy" },
}
