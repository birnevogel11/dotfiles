local async = require('plenary.async')
local config_util = require('yen3.util.config')

local map_n = config_util.map_n
local map_call_n = config_util.map_call_n
local async_cmd_notify= config_util.async_cmd_notify

local M = {}

M.rebase_remote_master = function()
  local current_branch = vim.fn.FugitiveHead()
  async.run(function()
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

M.fugitive = function()
  -- General
  map_call_n('<leader>g', function ()
    local cmd_args = vim.fn.input('Git ')
    vim.fn.execute("Git " .. cmd_args)
  end,
  "Git")

  -- Status
  map_n("<leader>gs", ":vertical topleft Git<cr>")

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
  map_n('<leader>go', "<cmd>Octo pr list<cr>")
  map_call_n('<leader>gk', function() async_cmd_notify({'gh', 'pr', 'check'}, "Github PR Check") end,
    "Git PR check"
  )

  -- It does not work. Enable it when it's fixed.
  -- map_n('<leader>gk', ":Octo pr checks<cr>")
end

return M
