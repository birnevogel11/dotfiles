-- source: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/lsp/status.lua
local nvim_status = require "lsp-status"

local M = {}

M.select_symbol = function(cursor_pos, symbol)
  if symbol.valueRange then
    local value_range = {
      ["start"] = {
        character = 0,
        line = vim.fn.byte2line(symbol.valueRange[1]),
      },
      ["end"] = {
        character = 0,
        line = vim.fn.byte2line(symbol.valueRange[2]),
      },
    }

    return require("lsp-status.util").in_range(cursor_pos, value_range)
  end
end

M.lsp_status = function()
  nvim_status.config {
    select_symbol = M.select_symbol,
    spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
  }

  nvim_status.register_progress()
end

M.on_attach = function(client)
  nvim_status.on_attach(client)

  local group = vim.api.nvim_create_augroup("yen3_lsp_status", { clear = true })
  vim.api.nvim_create_autocmd(
    {"CursorHold","BufEnter"},
    { callback = function() require('lsp-status').update_current_function() end,
      buffer = 0,
      group = group,
    }
  )
end

return M
