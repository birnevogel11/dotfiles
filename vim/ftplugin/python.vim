" Colorcolumn: {{{
set colorcolumn=80,120
" }}}
" Highlight: {{{
let python_highlight_all = 1
" }}}
" Black: {{{
nnoremap <buffer><silent> <leader>bb :lua require("yen3.plugin").python_black_format()<cr>
" }}}
" Indent: {{{
" set python indention
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
set autoindent
set fileformat=unix
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
