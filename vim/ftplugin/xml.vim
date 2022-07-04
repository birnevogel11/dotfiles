if executable('xmllint')
  nnoremap <leader>bb ::%!xmllint --format --encode UTF-8 -<cr>
endif
