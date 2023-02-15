local M = {}
local wezterm = require 'wezterm'

local harfbuzz_features = {
  "zero", -- Use a slashed zero '0' (instead of dotted)
  "kern", -- (default) kerning (todo check what is really is)
  "liga", -- (default) ligatures
  "clig", -- (default) contextual ligatures
}

local macos_font_config = {
  font = wezterm.font('SauceCodePro Nerd Font'),
  font_size = 22,
  freetype_load_target = "Light",
  adjust_window_size_when_changing_font_size = false,
  warn_about_missing_glyphs = false,
  harfbuzz_features = harfbuzz_features,
}

M.get_font_config = function()
  if wezterm.target_triple == "x86_64-apple-darwin" then
    return macos_font_config
  else
    return {}
  end
end

return M
