" Indention: {{{
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal expandtab
setlocal textwidth=79
setlocal wrap
" }}}
" Haskell-vim: {{{
let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_arrowsyntax = 1
let g:haskell_enable_pattern_synonyms = 1
let g:haskell_enable_typeroles = 1
let g:haskell_enable_static_pointers = 1
let g:haskell_backpack = 1

let g:haskell_indent_if = 3
let g:haskell_indent_case = 2
let g:haskell_indent_let = 2
let g:haskell_indent_where = 6
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1
let g:haskell_indent_guard = 2
let g:haskell_indent_case_alternative = 2
" }}}
" vim-stylishask: {{{
let g:stylishask_on_save = 0

nnoremap <buffer> <leader>bb  :Stylishask<cr>
" }}}
" Hoogle search: {{{
function! Yen3HoogleSearch()
    let word = expand('<cword>')
    execute ":Hoogle " . word
endfunction

function! Yen3HoogleInfoSearch()
    let word = expand('<cword>')
    execute ":HoogleInfo " . word
endfunction

nnoremap <silent> <buffer> Q :call Yen3HoogleSearch()<CR>
nnoremap <silent> <buffer> <leader>q :call Yen3HoogleInfoSearch()<CR>
" }}}
" vim: ft=vim foldmethod=marker foldcolumn=1
