if vim.fn.executable("xmllint") == 1 then
  require('yen3.lib.keymap').keymap_n("<leader>bb", ":%!xmllint --format --encode UTF-8 -<cr>")
end
