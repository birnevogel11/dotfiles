--- Replace the first word
--- @param action string action word
local rebase_action = function(action)
  vim.cmd("normal! ^cw" .. action)
  vim.cmd("normal! ^")
end

local rebase_keymap = function(key, word)
  vim.keymap.set("n", "<leader>v" .. key, function() rebase_action(word) end, { desc = "Git base: ".. word})
end

-- p, pick <commit> = use commit
-- r, reword <commit> = use commit, but edit the commit message
-- e, edit <commit> = use commit, but stop for amending
-- s, squash <commit> = use commit, but meld into previous commit
-- f, fixup <commit> = like "squash", but discard this commit's log message
rebase_keymap("p", "pick")
rebase_keymap("r", "reword")
rebase_keymap("f", "fixup")
rebase_keymap("s", "squash")
rebase_keymap("d", "drop")
rebase_keymap("e", "edit")
