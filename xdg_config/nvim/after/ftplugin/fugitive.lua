vim.keymap.set("n", "<leader>gq", function()
  if vim.fn.bufnr("$") == 1 then
    vim.cmd [[ quit ]]
  else
    vim.cmd [[ bdelete ]]
  end
end, {desc = "Close the fugitive", buffer = 0})
