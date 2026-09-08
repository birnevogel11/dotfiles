-- Edit
vim.keymap.set("n", "<leader>du", ":nohl<cr>")

vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("n", ">", "v>")
vim.keymap.set("n", "<", "v<")

vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set(
  "n",
  "<leader>wr",
  ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "Replace current word" }
)
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Past word" })
vim.keymap.set("i", "<C-c>", "<Esc>")


-- Tab
vim.keymap.set("n", "<leader>tc", ":tabnew<cr>", { desc = "Tab: new" })
vim.keymap.set("n", "<leader>tj", ":+tabmove<cr>", { desc = "Tab: move next" })
vim.keymap.set("n", "<leader>tk", ":-tabmove<cr>", { desc = "Tab: move prev" })
vim.keymap.set("n", "<C-N>", ":tabnext<cr>", { desc = "Tab: switch to next" })
vim.keymap.set("n", "<C-P>", ":tabprev<cr>", { desc = "Tab: switch to prev" })

-- Misc
vim.keymap.set("n", "<leader>wv", function() vim.cmd.restart() end)

vim.keymap.set("n", "<leader>xr", "<cmd>!chmod +x %<CR>", { desc = "Chmod executable" })

vim.keymap.set("n", "<leader>wp", function()
  print(vim.fn.expand("%:p"))
end, { desc = "Show current file path" })

vim.keymap.set("n", "<leader>wn", function()
  ---@diagnostic disable-next-line: undefined-field
  vim.opt.relativenumber = not vim.opt.relativenumber._value
end, { desc = "Toogle relative number" })

vim.keymap.set("n", "<leader>wm", function()
  ---@diagnostic disable-next-line: undefined-field
  local value = vim.opt.mouse._value
  if value == "nvi" then
    vim.opt.mouse = ""
    vim.notify("Disable", vim.log.levels.INFO, { title = "Mouse mode" })
  else
    vim.opt.mouse = "nvi"
    vim.notify("Enable: nvi", vim.log.levels.INFO, { title = "Mouse mode" })
  end
end, { desc = "Toggle mouse mode" })

vim.keymap.set("n", "<leader>wa", function()
  vim.notify("Source current file" .. vim.fn.expand("%:p"))
  vim.api.nvim_command("luafile %")
end)

vim.keymap.set("n", "<leader>wf", function()
  -- ref: https://www.reddit.com/r/neovim/comments/ol2vx4/how_to_toggle_quickfix_with_lua/
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo() or {}) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end

  if qf_exists then
    vim.fn.execute("cclose")
  else
    vim.fn.execute("copen 10")
  end
end, { desc = "Toggle quickfix win" })

vim.keymap.set("n", "<leader>u", vim.cmd.Undotree, { desc = "Toggle undotree" })
