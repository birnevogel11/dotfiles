---@param cmd table<string>
---@param title string
---@return any
local mk_git_cmd_func = function(cmd, title)
  return function()
    require("bv11.lib.notify").async_cmd_notify(cmd, title)
  end
end

local git_status = function()
  vim.fn.execute(":vertical topleft Git")
  vim.api.nvim_win_set_width(0, 80)
end

local git_blame = function()
  vim.cmd([[ Git blame ]])
  vim.api.nvim_set_option_value("wrap", false, { scope = "local", win = 0 })
end

return {
  {
    "tpope/vim-fugitive",
    lazy = false,
    keys = {
      -- Git status
      { "<leader>gs", git_status, desc = "Git: status" },

      -- Push
      { "<leader>gp", mk_git_cmd_func({'git', 'push'}, "Git push"), desc = "Git: Push"},
      { "<leader>gf", mk_git_cmd_func({'git', 'push', '-f'}, "Git forced push"), desc = "Git: Forced Push"},
      { "<leader>gpp", mk_git_cmd_func({'git', 'push', 'origin', "HEAD:refs/for/master" }, "Git push refspec"), desc = "Git: push gerrit master"},

      -- Pull
      { "<leader>gu", mk_git_cmd_func({'git', 'pull'}, "Git pull"), desc = "Git: Pull"},

      -- Rebase
      { "<leader>gr", ":Git rebase -i origin/master<cr>", desc = "Git: rebase master" },

      -- Misc
      { "<leader>gb", git_blame, desc = "Git: blame" },
      { "<leader>gA", ":Git add --patch", desc = "Git: add patch" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    branch = "main",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    event = "VeryLazy",
  },

  {
    "esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff",
    keys = {
      { "<leader>gd", ":CodeDiff<cr>", desc = "CodeDiff" },
    },
  },

  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {},
    keys = {
      {"<leader>ge", ":DiffviewOpen<cr>", desc = "Diffview Open"},
      {"<leader>gd", ":DiffviewOpen HEAD~<cr>", desc = "Diffview Open HEAD~" },
      {"<leader>gl", ":DiffviewFileHistory<cr>", desc = "Diffview git history"},
      {"<leader>gL", ":DiffviewFileHistory %<cr>", desc = "Diffview current file fistory"},
      {"<leader>gq", ":DiffviewClose<cr>", desc = "Diffview Close"},
    }
  },

  { "akinsho/git-conflict.nvim", version = "*", config = true, event = "VeryLazy" },
}
