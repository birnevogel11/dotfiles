local lib_notify = require("yen3.lib.notify")

local keymap_n = require("yen3.lib.keymap").keymap_n
local async_cmd_notify = lib_notify.async_cmd_notify

local fugitive_setup = function()
  -- General
  -- keymap_n("<leader>g", function()
  --   ---@diagnostic disable-next-line: param-type-mismatch
  --   local cmd_args = vim.fn.input("Git ")
  --   vim.fn.execute("Git " .. cmd_args)
  -- end, "Git")

  -- Status
  keymap_n("<leader>gs", function()
    vim.fn.execute(":vertical topleft Git")
    vim.api.nvim_win_set_width(0, 80)
  end)

  -- Checkout
  -- <leader>gc -- checkout to another branch.
  -- It's defined in lua/yen3/plugins/search/base.lua
  keymap_n("<leader>gC", function()
    async_cmd_notify({ "git", "checkout", "master" }, "Git checkout master")
  end, "Git checkout master")

  -- Push
  keymap_n("<leader>gp", function()
    async_cmd_notify({ "git", "push" }, "Git push")
  end, "Git push")
  keymap_n("<leader>gf", function()
    async_cmd_notify({ "git", "push", "-f" }, "Git force push")
  end, "Git force push")
  keymap_n("<leader>gpp", function()
    async_cmd_notify({ "git", "push", "origin", "HEAD:refs/for/master" }, "Git push refspec")
  end, "Git push gerrit")

  -- Pull
  keymap_n("<leader>gu", function()
    async_cmd_notify({ "git", "pull" }, "Git pull")
  end, "Git pull")
  keymap_n("<leader>gU", function()
    async_cmd_notify({ "git", "pull", "--rebase" }, "Git pull --rebase")
  end, "Git pull --rebase")

  -- Rebase
  keymap_n("<leader>gr", ":  Git rebase -i origin/master<cr>")
  keymap_n("<leader>gR", require("yen3.lib.git").rebase_remote_master, "Git pull and rebase remote master")
  keymap_n("<leader>gri", ":Git rebase -i")

  -- Misc
  keymap_n("<leader>gA", ":Git add --patch<cr>")
  keymap_n("<leader>gb", function()
    vim.cmd [[ Git blame ]]
    vim.api.nvim_set_option_value("wrap", false, { scope = "local", win = 0 })
  end)

end

local diffview_setup = function()
  require("diffview").setup({
    keymaps = {
      view = {
        { "n", "<leader>gd", ":DiffviewOpen<cr>" },
        { "n", "<leader>gl", ":DiffviewFileHistory<cr>" },
        { "n", "<leader>gL", ":DiffviewFileHistory %<cr>" },
        { "n", "<leader>gq", ":DiffviewClose<cr>" },
      }
    }
  })

  keymap_n("<leader>gd", ":DiffviewOpen<cr>")
  keymap_n("<leader>gl", ":DiffviewFileHistory<cr>")
  keymap_n("<leader>gL", ":DiffviewFileHistory %<cr>")
  keymap_n("<leader>gq", ":DiffviewClose<cr>")
end

return {
  -- Git
  { "tpope/vim-fugitive",        config = function() fugitive_setup() end, },
  {
    "lewis6991/gitsigns.nvim",
    branch = "main",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    event = "VeryLazy",
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewFileHistory", "DiffviewOpen" },
    keys = { "<leader>gd", "<leader>gl", "<leader>gL", "<leader>gq" },
    config = function() diffview_setup() end,
    -- event = "VeryLazy",
  },
  { 'akinsho/git-conflict.nvim', version = "*", config = true, event = "VeryLazy" },
}
