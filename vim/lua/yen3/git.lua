local config_util = require('yen3.util.config')
local Job = require('plenary.job')
local notify = require("notify")

local M = {
  cmd = {}
}

M.fugitive = function()
  local map_n = config_util.map_n
  config_util.set_keymap_call_n('<leader>g',
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
  config_util.set_keymap_call_n("<leader>gp",
     function() M.async_cmd_notify({'git', 'push'}, "Git push") end
  )
  config_util.set_keymap_call_n("<leader>gf",
     function() M.async_cmd_notify({'git', 'push', '-f'}, "Git force push") end
  )
  config_util.set_keymap_call_n("<leader>gpp",
     function() M.async_cmd_notify({'git', 'push', 'origin', 'HEAD:refs/for/master'}, "Git push refspec") end
  )
  config_util.set_keymap_call_n("<leader>gP",
     function() M.async_cmd_notify({'git', 'pull'}, "Git push refspec") end
  )

  -- Rebase
  map_n("<leader>gr", ":Git rebase -i origin/master<cr>")
  map_n("<leader>gri", ":Git rebase -i")
  config_util.set_keymap_call_n("<leader>grr",
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

M.list_to_lines = function (tbl)
  local result = ""

  for _, line in ipairs(tbl) do
    if result == "" then
      result = line
    else
      result = result .. "\n" .. line
    end
  end

  return result
end

M.async_cmd_notify = function(cmd, title, cwd)
  title = title or ""
  cwd = cwd or vim.fn.getcwd()
  if type(cmd) ~= "table" then
    notify("cmd is not a table", "error", {title = "async_cmd_notify"})
    return
  end
  local command = table.remove(cmd, 1)

  Job:new({
    command = command,
    args = cmd,
    cwd = cwd,
    on_exit = function(j, _)
      local result = M.list_to_lines(
        {
          M.list_to_lines(j:result()),
          M.list_to_lines(j:stderr_result()),
        }
      )
      notify(result, "info", {title = title})
    end,
  }):sync()
end

return M
