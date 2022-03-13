local config_util = require('yen3.util.config')

local M = {
  cmd = {}
}

M.cmd.fugitive_git_command = function()
  local cmd_args = vim.fn.input('git ')
  vim.fn.execute("Git " .. cmd_args)
end

M.cmd.fugitive_git_pull_master = function()
  local current_branch = vim.fn.system('git branch --show-current')

  vim.fn.execute('silent !git checkout master')
  vim.fn.execute('silent !git pull')
  vim.fn.execute('silent !git checkout ' .. current_branch)
end

M.cmd.fugitive_git_rebase_origin_master = function()
  vim.fn.execute('silent !git fetch origin master')
  vim.fn.execute(':Git rebase -i origin/master')
end

M.cmd.fugitive_push_current_branch = function()
  local current_branch = vim.fn.system('git branch --show-current')
  vim.fn.execute(':Git push -u origin ' .. current_branch)
end

M.fugitive_gina = function()
  local map_n = config_util.map_n
  map_n('<leader>g', ":lua require('yen3.git').cmd.fugitive_git_command()<cr>")

  -- map_n('<leader>gc', ":Git checkout ")

  map_n("<leader>gs", ":vertical topleft Git<cr>")

  -- map_n("<leader>gA", ":Git add --patch<cr>")

  map_n("<leader>gd",  ":Git diff<cr>")
  map_n("<leader>gdd", ":Gvdiffsplit!<cr>")

  map_n("<leader>gb",  ":Git blame<cr>")
  map_n("<leader>gB",  ":Gina blame<cr>")

  map_n("<leader>gp",  ":Gina! push<cr>")
  -- map_n('<leader>gp',  ":lua require('yen3.git').cmd.fugitive_push_current_branch()<cr>")
  map_n('<leader>gf',  ":Git push -f<cr>")
  map_n("<leader>gpp", ":Gina! push origin HEAD:refs/for/master<cr>")

  map_n("<leader>gP",  ":Gina! pull<cr>")
  map_n("<leader>gpm", ":lua require('yen3.plugin').cmd.fugitive_git_pull_master()<cr>")

  map_n("<leader>gr", ":Git rebase -i origin/master<cr>")
  map_n("<leader>grr", ":lua require('yen3.git').cmd.fugitive_git_rebase_origin_master<cr>")
  map_n("<leader>gri", ":Git rebase -i")

  M._lazyload_keymap()
end

M.neogit = function()
  require('neogit').setup {
    disable_commit_confirmation = true,
    integrations = {
      diffview = true,
    },
  }
end

M.diffview = function()
  require('diffview').setup {
    use_icons = false,
    file_panel = {
      width = 20,
    },
  }
end

M._flog_curr_buff = function()
  local cmd="Flog -path=" .. vim.fn.expand('%:p')
  vim.cmd(cmd)
end

M._lazyload_keymap = function()
  -- Neogit
  -- config_util.map_n("<leader>gg", ":Neogit<cr>")

  -- Octo
  config_util.map_n('<leader>go', "<cmd>Octo pr list<cr>")
  config_util.map_n('<leader>gk', "<cmd>!gh pr checks<cr>")
  -- It does not work. Enable it when it's fixed.
  -- config_util.map_n('<leader>gk', ":Octo pr checks<cr>")

  -- Flog
  config_util.map_n('<leader>gl', "<cmd>Flog<cr>")
  config_util.map_n('<leader>gL', "<cmd>lua require('yen3.git')._flog_curr_buff()<cr>")
end

return M
