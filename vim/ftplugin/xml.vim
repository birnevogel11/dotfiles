if executable('xmllint')
  au FileType xml exe ":silent %!xmllint --format --recover - 2>/dev/null"
endif
