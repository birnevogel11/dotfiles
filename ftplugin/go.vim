let g:go_fmt_command = "goimports"

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

let g:ale_go_langserver_executable = 'gopls'

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

au FileType go nmap <leader>m  <Plug>(go-build)
au FileType go nmap <leader>mr <Plug>(go-run)
au FileType go nmap <leader>mt <Plug>(go-test)
au FileType go nmap <leader>mc <Plug>(go-coverage)
au FileType go nmap <leader>ml :GoMetaLinter<cr>

" Autocomplete with vim-go rather deoplete
" ref: https://github.com/fatih/vim-go/issues/2185
call deoplete#custom#option('omni_patterns', {
\ 'go': '[^. *\t]\.\w*',
\})
