--- @param line string
--- @param action string
--- @return string
local replace_first_word = function(line, action)
  return line:gsub("^(%s*)%S+", "%1" .. action, 1)
end

--- Replace the first word on the current line
--- @param action string action word
local rebase_action = function(action)
  local new_line = replace_first_word(vim.api.nvim_get_current_line(), action)
  vim.api.nvim_set_current_line(new_line)
  local col = new_line:find("%S") or 1
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_win_set_cursor(0, { row, col - 1 })
end

--- Replace the first word on each line in the visual selection
--- @param action string action word
local rebase_action_visual = function(action)
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  for i, line in ipairs(lines) do
    lines[i] = replace_first_word(line, action)
  end
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end

local rebase_keymap = function(key, word)
  vim.keymap.set("n", "<leader>v" .. key, function() rebase_action(word) end, { desc = "Git base: ".. word})
  vim.keymap.set("x", "<leader>v" .. key, function() rebase_action_visual(word) end, { desc = "Git base: ".. word})
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
