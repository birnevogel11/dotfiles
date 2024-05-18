local wezterm = require 'wezterm'
local utils = require 'utils'

local harfbuzz_features = {
  -- "zero", -- Use a slashed zero '0' (instead of dotted)
  "kern", -- (default) kerning (todo check what is really is)
  "liga", -- (default) ligatures
  "clig", -- (default) contextual ligatures
}

local base_font_config = {
  adjust_window_size_when_changing_font_size = false,
  warn_about_missing_glyphs = false,
  harfbuzz_features = harfbuzz_features,
}

local get_font_config = function()
  if wezterm.target_triple == "x86_64-apple-darwin" then
    return {
      font = wezterm.font('SauceCodePro Nerd Font'),
      font_size = 22,
      -- freetype_load_target = "Light",
      -- freetype_load_flags = 'NO_HINTING|MONOCHROME',
    }
  else
    return {
      font = wezterm.font('SauceCodePro Nerd Font'),
      font_size = 18,
      -- freetype_load_target = "Light",
      -- freetype_load_flags = 'NO_HINTING|MONOCHROME',
    }
  end
end

return utils.merge_tables(base_font_config, get_font_config())
