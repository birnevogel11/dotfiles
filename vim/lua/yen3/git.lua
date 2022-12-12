local async = require('plenary.async')
local config_util = require('yen3.util.config')

local map_n = config_util.map_n
local map_call_n = config_util.map_call_n
local async_cmd_notify= config_util.async_cmd_notify

local M = {}

M.rebase_remote_master = function()
  local current_branch = vim.fn.FugitiveHead()
  ---@diagnostic disable-next-line: missing-parameter
  async.run(function(_, _)
    local notify = require('notify').async
    notify("Checkout and pulling ...", "info", {title = "Git rebase origin/master"})

    if current_branch ~= "master" then
      vim.fn.execute('Git checkout master')
    end

    vim.fn.execute('Git pull')
    notify("Update submodule recursively", "info", {title = "Git master branch"})
    vim.fn.execute('Git submodule update --init --recursive')

    if current_branch ~= "master" then
      vim.fn.execute('Git checkout ' .. current_branch)
      notify("Checkout back to " .. current_branch, "info", {title = "Git checkout"})
      vim.fn.execute('Git rebase -i origin/master')
    end
  end)
end


M.pull_upstream_rebase = function()
  local current_branch = vim.fn.FugitiveHead()

  ---@diagnostic disable-next-line: missing-parameter
  async.run(function(_, _)
    local notify = require('notify').async
    notify("Fetch upstream/master and rebase force", "info", {title = "Git update master"})

    local execute_and_notify = function(cmd)
      notify(cmd, "info", {title = "Run cmd"})
      vim.fn.execute(cmd)
    end

    execute_and_notify('Git fetch upstream master')
    execute_and_notify('Git checkout master')
    execute_and_notify('Git reset --hard upstream/master')
    execute_and_notify('Git push -f')
    execute_and_notify('Git submodule update --init --recursive')

    if current_branch ~= "master" then
      vim.fn.execute('Git checkout ' .. current_branch)
      notify("Checkout back to " .. current_branch, "info", {title = "Git checkout"})
    end
  end)

end

M.fugitive = function()
  -- General
  map_call_n('<leader>g', function ()
  ---@diagnostic disable-next-line: param-type-mismatch
    local cmd_args = vim.fn.input('Git ')
    vim.fn.execute("Git " .. cmd_args)
  end,
  "Git")

  -- Status
  map_call_n("<leader>gs", function()
    vim.fn.execute(":vertical topleft Git")
    vim.api.nvim_win_set_width(0, 80)
  end)

  -- Checkout
  map_call_n('<leader>gC',
    function() async_cmd_notify({'git', 'checkout', 'master'}, "Git checkout master") end,
    "Git checkout master"
  )

  -- Push
  map_call_n("<leader>gp", function() async_cmd_notify({'git', 'push'}) end, "Git push")
  map_call_n("<leader>gf", function() async_cmd_notify({'git', 'push', '-f'}, "Git force push") end, "Git force push")
  map_call_n("<leader>gpp",
    function() async_cmd_notify({'git', 'push', 'origin', 'HEAD:refs/for/master'}, "Git push refspec") end,
    "Git push gerrit"
  )

  -- Pull
  map_call_n("<leader>gu", function() async_cmd_notify({'git', 'pull'}, "Git pull") end, "Git pull")
  map_call_n(
    "<leader>gU",
    function() async_cmd_notify({'git', 'pull', '--rebase'}, "Git pull --rebase") end,
    "Git pull --rebase"
  )

  -- Rebase
  map_n("<leader>gr",  ":  Git rebase -i origin/master<cr>")
  map_call_n("<leader>gR", M.rebase_remote_master, "Git pull and rebase remote master")
  map_n("<leader>gri",     ":Git rebase -i")

  -- Misc
  map_n("<leader>gA", ":Git add --patch<cr>")
  map_n("<leader>gb",  ":Git blame<cr>")

  -- Diffview
  map_n("<leader>gd", ":DiffviewOpen<cr>")
  map_n("<leader>gl", ":DiffviewFileHistory<cr>")
  map_n("<leader>gL", ":DiffviewFileHistory %<cr>")
  map_n("<leader>gq", ":DiffviewClose<cr>")

  -- Octo
  map_call_n('<leader>go', function()
    config_util.notify("Edit Pull request", "Please wait ...", "info")
    local raw_output = vim.fn.system("gh pr view | grep number | awk -F':' '{print $2}'")
    local pr_number = string.gsub(string.gsub(raw_output, "\t", ""), "\n", "")
    vim.fn.execute("Octo pr edit " .. pr_number)
  end)
  map_n('<leader>goo', "<cmd>Octo pr list<cr>")
  map_call_n('<leader>gk', function() async_cmd_notify({'gh', 'pr', 'checks'}, "Github PR Check") end,
    "Git PR check"
  )

  -- It does not work. Enable it when it's fixed.
  -- map_n('<leader>gk', ":Octo pr checks<cr>")
end

return M
