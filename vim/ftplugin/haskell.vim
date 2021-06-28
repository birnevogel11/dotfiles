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
" vim-hident: {{{
let g:hindent_on_save = 0
nnoremap <buffer> <leader>bi  :Hindent<cr>
" }}}
" Hoogle search: {{{
nnoremap <buffer> qq :Hoogle <C-r><C-w><CR>
nnoremap <buffer> <leader>dq :Hoogle
" }}}
" ale: {{{
" floating-window setting
let g:ale_enabled = 0
" let g:ale_floating_preview = 1
" let g:ale_hover_to_preview = 1
" let g:ale_hover_to_floating_preview = 1
" let g:ale_detail_to_floating_preview = 1
" let g:ale_close_preview_on_insert = 0
" let g:ale_cursor_detail = 1
" let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']
" }}}
" fzf: {{{
if executable('lushtags')
  let g:fzf_tags_command = 'lushtags --ignore-parse-error --'
endif
" }}}
" lushtags: {{{
if executable('lushtags')
    let g:tagbar_type_haskell = {
        \ 'ctagsbin' : 'lushtags',
        \ 'ctagsargs' : '--ignore-parse-error --',
        \ 'kinds' : [
            \ 'm:module:0',
            \ 'e:exports:1',
            \ 'i:imports:1',
            \ 't:declarations:0',
            \ 'd:declarations:1',
            \ 'n:declarations:1',
            \ 'f:functions:0',
            \ 'c:constructors:0'
        \ ],
        \ 'sro' : '.',
        \ 'kind2scope' : {
            \ 'd' : 'data',
            \ 'n' : 'newtype',
            \ 'c' : 'constructor',
            \ 't' : 'type'
        \ },
        \ 'scope2kind' : {
            \ 'data' : 'd',
            \ 'newtype' : 'n',
            \ 'constructor' : 'c',
            \ 'type' : 't'
        \ }
    \ }
endif
" }}}
" denite-outline: {{{
" Set haskell tags binary
if g:yen3_search_selection == 1
  call denite#custom#var('outline', 'command', ['hasktags'])
  call denite#custom#var('outline', 'options', ['-c'])
endif
" }}}
" vim: ft=vim foldmethod=marker foldcolumn=1
