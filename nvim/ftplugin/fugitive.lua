require('yen3.lib.keymap').keymap_n("<leader>gq", function()
  if vim.fn.bufnr("$") == 1 then
    vim.cmd [[ quit ]]
  else
    vim.cmd [[ bdelete ]]
  end
end)
