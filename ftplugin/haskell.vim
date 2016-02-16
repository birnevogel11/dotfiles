""" For YCM setting
let g:ycm_semantic_triggers = {'haskell' : ['.']}

""" neo-ghc setting
"autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

""" Haskell map
autocmd FileType haskell nnoremap <silent><F5> :!hasktags -c .<CR>
autocmd FileType haskell nnoremap <buffer><F6> :HdevtoolsType<CR>
autocmd FileType haskell nnoremap <buffer><silent><F7> :HdevtoolsClear<CR>
autocmd FileType haskell nnoremap <buffer><silent><F8> :HdevtoolsInfo<CR>

