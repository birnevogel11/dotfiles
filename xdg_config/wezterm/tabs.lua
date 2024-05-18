local wezterm = require 'wezterm'

-- reference: https://github.com/wez/wezterm/discussions/628#discussioncomment-1874614
local SUB_IDX = {"₁","₂","₃","₄","₅","₆","₇","₈","₉","₁₀",
                 "₁₁","₁₂","₁₃","₁₄","₁₅","₁₆","₁₇","₁₈","₁₉","₂₀"}

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local id = SUB_IDX[tab.tab_index+1]
  local process_name = tab.active_pane.foreground_process_name
  local exec_name = basename(process_name):gsub("%.exe$", "")
  local title = wezterm.truncate_right(exec_name, max_width)

  return {
    {Attribute={Intensity="Bold"}},
    {Text=id},
    {Text="  " .. title .. "  "},
    {Attribute={Intensity="Normal"}},
  }
end)

return {
  use_fancy_tab_bar =  false,
  hide_tab_bar_if_only_one_tab = true,
  enable_scroll_bar = true,
}
