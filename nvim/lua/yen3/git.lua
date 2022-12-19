local async = require("plenary.async")
local lib_notify = require("yen3.lib.notify")

local keymap_n = require("yen3.lib.keymap").keymap_n
local async_cmd_notify = lib_notify.async_cmd_notify

local M = {}

M.rebase_remote_master = function()
  local current_branch = vim.fn.FugitiveHead()
  ---@diagnostic disable-next-line: missing-parameter
  async.run(function(_, _)
    lib_notify.notify_async("Git rebase origin/master", "Checkout and pulling ...", "info")

    if current_branch ~= "master" then
      vim.fn.execute("Git checkout master")
    end

    vim.fn.execute("Git pull")

    async_cmd_notify("Git master branch", "Update submodule recursively", "info")
    vim.fn.execute("Git submodule update --init --recursive")

    if current_branch ~= "master" then
      vim.fn.execute("Git checkout " .. current_branch)
      lib_notify.notify_async("Git chekcout", "Checkout back to " .. current_branch, "info")
      vim.fn.execute("Git rebase -i origin/master")
    end
  end)
end

M.pull_upstream_rebase = function()
  local current_branch = vim.fn.FugitiveHead()

  ---@diagnostic disable-next-line: missing-parameter
  async.run(function(_, _)
    lib_notify.notify_async("Git update master", "Fetch upstream/master and rebase force", "info")

    local execute_and_notify = function(cmd)
      lib_notify.notify_async("Run cmd", cmd, "info")
      vim.fn.execute(cmd)
    end

    execute_and_notify("Git fetch upstream master")
    execute_and_notify("Git checkout master")
    execute_and_notify("Git reset --hard upstream/master")
    execute_and_notify("Git push -f")
    execute_and_notify("Git submodule update --init --recursive")

    if current_branch ~= "master" then
      vim.fn.execute("Git checkout " .. current_branch)
      lib_notify.notify_async("Git chekcout", "Checkout back to " .. current_branch, "info")
    end
  end)
end

M.fugitive_setup = function()
  -- General
  keymap_n("<leader>g", function()
    ---@diagnostic disable-next-line: param-type-mismatch
    local cmd_args = vim.fn.input("Git ")
    vim.fn.execute("Git " .. cmd_args)
  end, "Git")

  -- Status
  keymap_n("<leader>gs", function()
    vim.fn.execute(":vertical topleft Git")
    vim.api.nvim_win_set_width(0, 80)
  end)

  -- Checkout
  keymap_n("<leader>gC", function()
    async_cmd_notify({ "git", "checkout", "master" }, "Git checkout master")
  end, "Git checkout master")

  -- Push
  keymap_n("<leader>gp", function()
    async_cmd_notify({ "git", "push" })
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
  keymap_n("<leader>gR", M.rebase_remote_master, "Git pull and rebase remote master")
  keymap_n("<leader>gri", ":Git rebase -i")

  -- Misc
  keymap_n("<leader>gA", ":Git add --patch<cr>")
  keymap_n("<leader>gb", ":Git blame<cr>")

  -- Diffview
  keymap_n("<leader>gd", ":DiffviewOpen<cr>")
  keymap_n("<leader>gl", ":DiffviewFileHistory<cr>")
  keymap_n("<leader>gL", ":DiffviewFileHistory %<cr>")
  keymap_n("<leader>gq", ":DiffviewClose<cr>")
end

return M
