local config_util = require('yen3.util.config')

local M = {
  cmd = {}
}

M.fugitive_gina = function()
  local map_n = config_util.map_n
  map_n('<leader>g', ":lua require('yen3.git').cmd.fugitive_git_command()<cr>")

  -- map_n('<leader>gc', ":Git checkout ")

  map_n("<leader>gs", ":vertical topleft Git<cr>")

  -- map_n("<leader>gA", ":Git add --patch<cr>")

  map_n("<leader>gd",  ":DiffviewOpen<cr>")

  map_n("<leader>gb",  ":Git blame<cr>")
  map_n("<leader>gB",  ":Gina blame<cr>")

  map_n("<leader>gp",  ":Gina! push<cr>")
  map_n('<leader>gf',  ":Gina! push -f<cr>")
  map_n("<leader>gpp", ":Gina! push origin HEAD:refs/for/master<cr>")

  map_n("<leader>gP",  ":Gina! pull<cr>")

  map_n("<leader>gr", ":Git rebase -i origin/master<cr>")
  map_n("<leader>grr", ":lua require('yen3.git').cmd.fugitive_git_rebase_origin_master<cr>")
  map_n("<leader>gri", ":Git rebase -i")

  -- Flog
  map_n("<leader>gl", ":DiffviewFileHistory<cr>")
  map_n("<leader>gL", ":DiffviewFileHistory %<cr>")
  map_n("<leader>gq", ":DiffviewClose<cr>")

  -- Octo
  map_n('<leader>go', "<cmd>Octo pr list<cr>")
  map_n('<leader>gk', "<cmd>!gh pr checks<cr>")
  -- It does not work. Enable it when it's fixed.
  -- config_util.map_n('<leader>gk', ":Octo pr checks<cr>")
end

M.cmd.fugitive_git_command = function()
  local cmd_args = vim.fn.input('Git ')
  vim.fn.execute("Git " .. cmd_args)
end

M.cmd.fugitive_git_rebase_origin_master = function()
  vim.fn.execute('silent !git fetch origin master')
  vim.fn.execute(':Git rebase -i origin/master')
end

M.cmd.flog_curr_buff = function()
  local cmd="Flog -path=" .. vim.fn.expand('%:p')
  vim.cmd(cmd)
end

return M
