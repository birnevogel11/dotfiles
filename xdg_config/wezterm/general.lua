local wezterm = require 'wezterm'
local utils = require 'utils'

local window_padding = function()
  if wezterm.target_triple == "x86_64-apple-darwin" then
    return { left = 3, right = 3, top = 15, bottom = 2 }
  else
    return { left = 3, right = 3, top = 5, bottom = 3 }
  end
end

local general_config = {
  -- front_end = "WebGpu",
  window_decorations = "RESIZE",
  window_close_confirmation = "NeverPrompt",
  skip_close_confirmation_for_processes_named = {
    'bash',
    'sh',
    'zsh',
    'fish',
    'tmux',
  },
  check_for_updates = false,
  exit_behavior = "Close",
  window_padding = window_padding(),
}

local platform_specific_config = function ()
  if wezterm.target_triple == "x86_64-apple-darwin" then
    return {
      front_end = "WebGpu",
    }
  else
    return {}
  end
end

return utils.merge_tables(general_config, platform_specific_config())
