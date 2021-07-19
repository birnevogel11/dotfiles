" Syntax color: {{{
lua require('yen3.onedarkishii').ftplugin.haskell()
" }}}
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
" let g:fzf_tags_command = 'hasktags -x -c -o-'
let g:fzf_tags_command = 'hasktags -c -o-'
" }}}
" fzf-hoogle: {{{
nnoremap <buffer> qq :Hoogle <C-r><C-w><CR>
nnoremap <buffer> <leader>dq :Hoogle
if has('mac')
  let g:hoogle_open_link = "open -a Safari"
endif
" }}}
" haskstags: {{{
if executable("hasktags")
    let g:tagbar_type_haskell = {
        \ 'ctagsbin'    : 'hasktags',
        \ 'ctagsargs'   : '-x -c -o-',
        \ 'kinds'       : [
            \  'm:modules:0:1',
            \  'd:data:0:1',
            \  'd_gadt:data gadt:0:1',
            \  'nt:newtype:0:1',
            \  'c:classes:0:1',
            \  'i:instances:0:1',
            \  'cons:constructors:0:1',
            \  'c_gadt:constructor gadt:0:1',
            \  'c_a:constructor accessors:1:1',
            \  't:type names:0:1',
            \  'pt:pattern types:0:1',
            \  'pi:pattern implementations:0:1',
            \  'ft:function types:0:1',
            \  'fi:function implementations:0:1',
            \  'o:others:0:1'
        \ ],
        \ 'sro'          : '.',
        \ 'kind2scope'   : {
            \ 'm'        : 'module',
            \ 'd'        : 'data',
            \ 'd_gadt'   : 'd_gadt',
            \ 'c_gadt'   : 'c_gadt',
            \ 'nt'       : 'newtype',
            \ 'cons'     : 'cons',
            \ 'c_a'      : 'accessor',
            \ 'c'        : 'class',
            \ 'i'        : 'instance'
        \ },
        \ 'scope2kind'   : {
            \ 'module'   : 'm',
            \ 'data'     : 'd',
            \ 'newtype'  : 'nt',
            \ 'cons'     : 'c_a',
            \ 'd_gadt'   : 'c_gadt',
            \ 'class'    : 'ft',
            \ 'instance' : 'ft'
        \ }
    \ }
endif
" }}}
" vim: ft=vim foldmethod=marker foldcolumn=1
