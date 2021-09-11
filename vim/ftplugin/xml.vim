if executable('xmllint')
  au FileType xml nnoremap <leader>bb exe ":silent %!xmllint --format --recover - 2>/dev/null"
endif
