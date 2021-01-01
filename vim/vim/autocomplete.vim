if g:yen3_auto_complete_selection == 1
" Deoplete:{{{
set pumheight=15

" Use deoplete.
let g:deoplete#enable_at_startup = 1
call deoplete#custom#var("smart_case", 1)

set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set completeopt-=preview    "no scratch window

" inoremap <silent><expr> <Tab>
            " \ pumvisible() ? "\<C-n>" : "<Tab>"

" deoplete-jedi options (Python)
function! ChompedSystem( ... )
    return substitute(call('system', a:000), '\n\+$', '', '')
endfunction

let g:python3_host_prog = ChompedSystem('which python3')
""}}}
" nvim-lsp: {{{
:lua << EOF
require('yen3_autocomplete')
EOF
" }}}
" diagnostic-nvim: {{{
autocmd BufEnter * highlight LspDiagnosticsError gui=italic ctermbg=88 guibg=#870000
autocmd BufEnter * highlight LspDiagnosticsWarning gui=italic ctermbg=21 guibg=#878700
" }}}
endif
" UltiSnips :{{{
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:UltiSnipsSnippetDirectories = ['~/usr/rc/vim/snippets']
let g:UltiSnipsSnippetsDir = '~/usr/rc/vim/snippets'
let g:UltiSnipsEditSplit = 'context'
let g:UltiSnipsEnableSnipMate = 0
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
