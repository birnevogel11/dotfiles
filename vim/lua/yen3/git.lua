local config_util = require('yen3.util.config')

local M = {
  cmd = {}
}

function M.cmd.fugitive_git_command()
  local cmd_args = vim.fn.input('git ')
  vim.fn.execute("Git " .. cmd_args)
end

function M.cmd.fugitive_git_pull_master()
  local current_branch = vim.fn.system('git branch --show-current')

  vim.fn.execute('silent !git checkout master')
  vim.fn.execute('silent !git pull')
  vim.fn.execute('silent !git checkout ' .. current_branch)
end

function M.cmd.fugitive_git_rebase_origin_master()
  vim.fn.execute('silent !git fetch origin master')
  vim.fn.execute(':Git rebase -i origin/master')
end

function M.cmd.fugitive_push_current_branch()
  local current_branch = vim.fn.system('git branch --show-current')
  vim.fn.execute(':Git push -u origin ' .. current_branch)
end

function M.neogit()
  require'neogit'.setup {
    disable_commit_confirmation = true,
    integrations = {
      diffview = true,
    },
  }

  config_util.map_n("<leader>gg", ":Neogit<cr>")
end

function M.fugitive_gina()
  local map_n = config_util.map_n
  map_n('<leader>g', ":lua require('yen3.git').cmd.fugitive_git_command()<cr>")

  -- map_n('<leader>gc', ":Git checkout ")

  map_n("<leader>gs", ":vertical topleft Git<cr>")

  -- map_n("<leader>gA", ":Git add --patch<cr>")

  map_n("<leader>gd", ":Git diff<cr>")
  map_n("<leader>gdd", ":Gvdiffsplit!<cr>")

  map_n("<leader>gb", ":Git blame<cr>")
  map_n("<leader>gB", ":Gina blame<cr>")

  -- map_n("<leader>gp", ":Git push<cr>")
  map_n('<leader>gp',  ":lua require('yen3.git').cmd.fugitive_push_current_branch()<cr>")
  map_n('<leader>gf',  ":Git push -f<cr>")
  map_n("<leader>gpp", ":Gina! push origin HEAD:refs/for/master<cr>")

  map_n("<leader>gP", ":Dispatch! Git pull<cr>")
  map_n("<leader>gpm", ":lua require('yen3.plugin').cmd.fugitive_git_pull_master()<cr>")

  map_n("<leader>gr", ":Git rebase -i origin/master<cr>")
  map_n("<leader>grr", ":lua require('yen3.git').cmd.fugitive_git_rebase_origin_master<cr>")
  map_n("<leader>gri", ":Git rebase -i")
end

function M.gitsigns()
  require('gitsigns').setup()
end

function M.diff_view()
  require('diffview').setup {
    use_icons = false,
    file_panel = {
      width = 20,
    },
  }
end

function M.octo_nvim_setup()
  require('octo').setup()
  config_util.map_n('<leader>go', ":Octo pr list<cr>")
  config_util.map_n('<leader>gk', ":!gh pr checks<cr>")

  -- It does not work. Enable it when it's fixed.
  -- config_util.map_n('<leader>gk', ":Octo pr checks<cr>")
end

function M.setup()
  M.neogit()
  M.gitsigns()
  M.fugitive_gina()
  M.diff_view()
  M.octo_nvim_setup()
end

return M
