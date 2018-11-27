let g:go_fmt_command = "goimports"

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

au FileType go nmap <leader>m <Plug>(go-build)
au FileType go nmap <leader>mr <Plug>(go-run)
au FileType go nmap <leader>mt <Plug>(go-test)
au FileType go nmap <leader>mc <Plug>(go-coverage)
