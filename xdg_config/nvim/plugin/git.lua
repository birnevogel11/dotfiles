require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/tpope/vim-fugitive" },
  }, { confirm = false })

  local list_to_lines = function(tbl)
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

  --- TODO: Rewrite with copilot
  ---@param cmd table<string>
  ---@param title string
  ---@return any
  local mk_git_cmd_func = function(cmd, title)
    return function()
      local Job = require("plenary.job")

      local handle_output = function(j)
        return list_to_lines({ list_to_lines(j:result()), list_to_lines(j:stderr_result()) })
      end

      local command = table.remove(cmd, 1)
      Job:new({
        command = command,
        args = cmd,
        on_exit = function(j, return_val)
          local log_level = vim.log.levels.INFO
          if return_val ~= 0 then
            log_level = vim.log.levels.ERROR
          end

          vim.notify(title .. handle_output(j), log_level)
        end,
      }):start()
    end
  end

  -- Git status
  vim.keymap.set("n", "<leader>gs", function()
    vim.fn.execute(":vertical topleft Git")
    vim.api.nvim_win_set_width(0, 80)
  end, { desc = "Git: status" })

  -- Push
  vim.keymap.set("n", "<leader>gp", mk_git_cmd_func({'git', 'push'}, "Git push"), { desc = "Git: Push" })
  vim.keymap.set("n", "<leader>gf", mk_git_cmd_func({'git', 'push', '-f'}, "Git forced push"), { desc = "Git: Forced Push" })
  vim.keymap.set("n", "<leader>gpp", mk_git_cmd_func({'git', 'push', 'origin', "HEAD:refs/for/master" }, "Git push refspec"), { desc = "Git: push gerrit master" })

  -- -- Pull
  vim.keymap.set("n", "<leader>gu", mk_git_cmd_func({'git', 'pull'}, "Git pull"), { desc = "Git: Pull" })

  -- Rebase
  vim.keymap.set("n", "<leader>gr", ":Git rebase -i origin/master<cr>", { desc = "Git: rebase master" })

  -- Misc
  vim.keymap.set("n", "<leader>gb", function()
    vim.cmd("Git blame")
    vim.api.nvim_set_option_value("wrap", false, { scope = "local", win = 0 })
  end, { desc = "Git: blame" })
  vim.keymap.set("n", "<leader>gA", ":Git add --patch", { desc = "Git: add patch" })
end)

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/lewis6991/gitsigns.nvim", version = "main" },
  }, { confirm = false })

  require("gitsigns").setup()
end)
