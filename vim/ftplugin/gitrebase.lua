local keymap_n = require('yen3.lib.keymap').keymap_n

-- @param str the action
local rebase_action = function(action)
  vim.cmd("normal! ^cw" .. action)
end

-- p, pick <commit> = use commit
-- r, reword <commit> = use commit, but edit the commit message
-- e, edit <commit> = use commit, but stop for amending
-- s, squash <commit> = use commit, but meld into previous commit
-- f, fixup <commit> = like "squash", but discard this commit's log message
keymap_n("<leader>p", function() rebase_action("pick") end,   "Git rebase: pick")
keymap_n("<leader>r", function() rebase_action("reword") end, "Git rebase: reword")
keymap_n("<leader>f", function() rebase_action("fixup") end,  "Git rebase: fixup")
keymap_n("<leader>s", function() rebase_action("squash") end, "Git rebase: squash")
keymap_n("<leader>d", function() rebase_action("drop") end,   "Git rebase: drop")
keymap_n("<leader>e", function() rebase_action("edit") end,   "Git rebase: edit")
