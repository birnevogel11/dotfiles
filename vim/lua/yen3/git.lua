local config_util = require('yen3.util.config')

local M = {}

M.fugitive = function()
  local map_n = config_util.map_n
  local set_keymap_call_n = config_util.set_keymap_call_n

  set_keymap_call_n('<leader>g',
    function ()
      local cmd_args = vim.fn.input('Git ')
      vim.fn.execute("Git " .. cmd_args)
    end
  )
  map_n("<leader>gs", ":vertical topleft Git<cr>")
  -- map_n('<leader>gc', ":Git checkout ")
  -- map_n("<leader>gA", ":Git add --patch<cr>")
  map_n("<leader>gd",  ":DiffviewOpen<cr>")
  map_n("<leader>gb",  ":Git blame<cr>")
  set_keymap_call_n("<leader>gp", function() config_util.async_cmd_notify({'git', 'push'}, "Git push") end)
  set_keymap_call_n("<leader>gf", function() config_util.async_cmd_notify({'git', 'push', '-f'}, "Git force push") end)
  set_keymap_call_n("<leader>gpp",
    function() config_util.async_cmd_notify({'git', 'push', 'origin', 'HEAD:refs/for/master'}, "Git push refspec") end
  )
  set_keymap_call_n("<leader>gP", function() config_util.async_cmd_notify({'git', 'pull'}, "Git pull") end)

  -- Rebase
  map_n("<leader>gr", ":Git rebase -i origin/master<cr>")
  map_n("<leader>gri", ":Git rebase -i")
  set_keymap_call_n("<leader>grr",
    function()
      vim.fn.execute('silent !git fetch origin master')
      vim.fn.execute(':Git rebase -i origin/master')
    end
  )

  -- Diffview
  map_n("<leader>gl", ":DiffviewFileHistory<cr>")
  map_n("<leader>gL", ":DiffviewFileHistory %<cr>")
  map_n("<leader>gq", ":DiffviewClose<cr>")

  -- Octo
  map_n('<leader>go', "<cmd>Octo pr list<cr>")
  map_n('<leader>gk', "<cmd>!gh pr checks<cr>")
  -- It does not work. Enable it when it's fixed.
  -- config_util.map_n('<leader>gk', ":Octo pr checks<cr>")
end

return M
