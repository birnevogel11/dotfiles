" Indention: {{{
" GNU Coding Style
"setlocal cindent
"setlocal tabstop=8
"setlocal softtabstop=2
"setlocal shiftwidth=2
"setlocal noexpandtab
"setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,f0,h2,p4,t0,+2,(0,u0,w1,m0
"setlocal textwidth=80
"setlocal formatoptions-=ro formatoptions+=cqlt

" Google Coding Style
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal expandtab
setlocal textwidth=80
setlocal wrap

setlocal cindent
setlocal cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4
" }}}
" Clangformat: {{{
"" map to <Leader>cf in C/C++ code
nnoremap <buffer><leader>bb :<C-u>ClangFormat<cr>
vnoremap <buffer><leader>bf :ClangFormat<cr>
"" if you install vim-operator-user
map <buffer><Leader>x <Plug>(operator-clang-format)
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
