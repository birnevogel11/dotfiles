""" neo-ghc setting
" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

nnoremap <buffer> <leader>bb  :Autoformat<cr>
