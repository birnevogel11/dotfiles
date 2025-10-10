vim.wo.spell = true
vim.keymap.set("n", "<leader>wc", "<cmd>:RenderMarkdown toggle<cr>", { desc = "Toggle render markdown" })

-- Toggle markdown todo <-> done, add/remove date with Unicode symbol
function ToggleMarkdownTodo()
  local line = vim.api.nvim_get_current_line()
  local indent = line:match("^(%s*)") or ""

  -- Patterns for detecting todo and done lines
  local todo_pattern = "^(%s*[%-%*%+] %[ %] )(.-)$"
  local done_pattern = "^(%s*[%-%*%+] %[x%] )(.-)$"

  -- Date symbol and format
  local date_symbol = "✅"
  local date = os.date("%Y-%m-%d")

  if line:match(todo_pattern) then
    -- Toggle to done
    local new_line = line:gsub("%[ %]", "[x]") .. " " .. date_symbol .. " " .. date
    vim.api.nvim_set_current_line(new_line)

  elseif line:match(done_pattern) then
    -- Toggle back to todo and remove date+symbol
    local new_line = line
      :gsub("%[x%]", "[ ]")
      :gsub("%s*" .. date_symbol .. "%s*%d%d%d%d%-%d%d%-%d%d$", "")
    vim.api.nvim_set_current_line(new_line)

  else
    vim.notify("Not a markdown todo line (- [ ] or - [x])", vim.log.levels.INFO)
  end
end

-- Toggle markdown todo priority between 🔽, 🔼, ⏫ (circular)
local function escape_lua_pattern(s)
  -- escape Lua pattern magic characters
  return s:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

local function index_of(tbl, val)
  for i, v in ipairs(tbl) do
    if v == val then return i end
  end
  return nil
end

function ToggleMarkdownPriority()
  local line = vim.api.nvim_get_current_line()
  local priorities = { "🔽", "🔼", "⏫" }

  -- find current priority (plain find to avoid pattern issues)
  local current_priority = nil
  for _, sym in ipairs(priorities) do
    if line:find(sym, 1, true) then
      current_priority = sym
      break
    end
  end

  -- remove the existing priority (first occurrence) if present
  if current_priority then
    local pat = "%s*" .. escape_lua_pattern(current_priority)
    line = line:gsub(pat, "", 1)
  end

  -- choose next priority (circular). If none existed, set to low (🔽).
  local new_sym
  if not current_priority then
    new_sym = priorities[1] -- 🔽
  else
    local idx = index_of(priorities, current_priority) or 0
    if idx >= #priorities then
      new_sym = priorities[1]
    else
      new_sym = priorities[idx + 1]
    end
  end

  -- Insert priority BEFORE the date symbol (if present), otherwise append
  local date_start = line:find("✅", 1, true)
  local new_line
  if date_start then
    local before = line:sub(1, date_start - 1):gsub("%s+$", "") -- trim trailing spaces before insertion
    local after = line:sub(date_start)
    new_line = before .. " " .. new_sym .. " " .. after
  else
    new_line = line:gsub("%s+$", "") .. " " .. new_sym
  end

  vim.api.nvim_set_current_line(new_line)
end

vim.keymap.set("n", "<leader>tt", ToggleMarkdownTodo, { desc = "Toggle markdown todo/done" })
vim.keymap.set("n", "<leader>tp", ToggleMarkdownPriority, { desc = "Toggle markdown todo priority" })
