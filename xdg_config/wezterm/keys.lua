local wezterm = require("wezterm")

return {
  keys = {
    {
      key = "n",
      mods = "CTRL|SHIFT",
      action = wezterm.action.ToggleFullScreen,
    }
  }
}
