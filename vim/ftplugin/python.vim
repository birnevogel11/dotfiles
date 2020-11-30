" Highlight: {{{
let python_highlight_all = 1
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
let g:pymode_rope = 0

if g:yen3_auto_complete_selection == 1
  " Keymap for jedi-vim
  let g:jedi#goto_command = "<c-]>"
  let g:jedi#goto_assignments_command = "ga"
  let g:jedi#goto_definitions_command = "gd"
  let g:jedi#documentation_command = "K"
  let g:jedi#usages_command = "gu"
  let g:jedi#rename_command = "gr"
endif
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
