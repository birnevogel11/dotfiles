local keymap_n = require("bv11.lib.keymap").keymap_n

--- Replace the first word
--- @param action string action word
local rebase_action = function(action)
  vim.cmd("normal! ^cw" .. action)
  vim.cmd("normal! ^")
end

-- p, pick <commit> = use commit
-- r, reword <commit> = use commit, but edit the commit message
-- e, edit <commit> = use commit, but stop for amending
-- s, squash <commit> = use commit, but meld into previous commit
-- f, fixup <commit> = like "squash", but discard this commit's log message
keymap_n("<leader>vp", function()
  rebase_action("pick")
end, "Git rebase: pick")
keymap_n("<leader>vr", function()
  rebase_action("reword")
end, "Git rebase: reword")
keymap_n("<leader>vf", function()
  rebase_action("fixup")
end, "Git rebase: fixup")
keymap_n("<leader>vs", function()
  rebase_action("squash")
end, "Git rebase: squash")
keymap_n("<leader>vd", function()
  rebase_action("drop")
end, "Git rebase: drop")
keymap_n("<leader>ve", function()
  rebase_action("edit")
end, "Git rebase: edit")
