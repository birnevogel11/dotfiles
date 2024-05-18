local async = require("plenary.async")
local lib_notify = require("bv11.lib.notify")

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

return M
