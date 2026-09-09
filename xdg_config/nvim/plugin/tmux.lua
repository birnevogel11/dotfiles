require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/tmux-plugins/vim-tmux-focus-events" },
  }, { confirm = false })
end)

if vim.env.TMUX ~= nil then
  require("beaver.lazyload").on_vim_enter(function()
    vim.pack.add({
      { src = "https://github.com/alexghergh/nvim-tmux-navigation" },
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
end

if vim.env.HERDR_PANE_ID ~= nil then
  require("beaver.lazyload").on_vim_enter(function()
    vim.pack.add({
      { src = "https://github.com/bojackduy/nvim-herdr-navigation" },
    }, { confirm = false })

    local plugin = vim.pack.get({ "nvim-herdr-navigation" })[1]
    vim.opt.rtp:prepend(plugin.path .. "/nvim-herdr-navigation")

    require("herdr-navigation").setup({
      keybindings = {
        left = "<C-h>",
        down = "<C-j>",
        up = "<C-k>",
        right = "<C-l>",
      },
    })
  end)
end

