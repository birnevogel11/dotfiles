" Highlight: {{{
let python_highlight_all = 1
" }}}
" Black: {{{
nnoremap <buffer><silent><leader>bb :lua require("yen3.plugin").python_black_format()<cr>
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
" Autocomplete: {{{
" let deoplete#sources#jedi#show_docstring = 0
" let g:pymode_rope = 0

" Keymap for jedi-vim
" let g:jedi#goto_command = "<c-]>"
" let g:jedi#goto_assignments_command = "ga"
" let g:jedi#goto_definitions_command = "gd"
" let g:jedi#documentation_command = "K"
" let g:jedi#usages_command = "gu"
" let g:jedi#rename_command = "gr"
" let g:jedi#show_call_signatures = "0"
" let g:jedi#completions_enabled = 1
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
