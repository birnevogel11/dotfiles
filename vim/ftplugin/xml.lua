if vim.fn.executable("stack") == 1 then
  require('yen3.util.config').map_n("<leader>bb", ":%!xmllint --format --encode UTF-8 -<cr>")
end
