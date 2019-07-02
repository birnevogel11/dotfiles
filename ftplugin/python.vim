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
" GoToDefinition: {{{
if g:yen3_auto_complete_selection == 1
  " Keymap for jedi-vim
  let g:jedi#goto_command = "<c-]>"
  let g:jedi#goto_assignments_command = "ga"
  let g:jedi#goto_definitions_command = "gd"
  let g:jedi#documentation_command = "K"
  let g:jedi#usages_command = "gu"
  let g:jedi#rename_command = "gr"
elseif g:yen3_auto_complete_selection == 2
  nnoremap <c-]> :call Yen3GoToDefinition()<cr>
endif
" }}}
" Pymode: {{{
"let g:pymode = 1
"let g:pymode_folding = 0
"let g:pymode_trim_whitespaces = 1
"let g:pymode_options = 1
"let g:pymode_python = 'python3'
"let g:pymode_motion = 1
"let g:pymode_lint = 0
"let g:pymode_rope = 0

"let g:pymode_syntax = 1
"let g:pymode_syntax_all = 1
"let g:pymode_syntax_print_as_function = 0
"let g:pymode_syntax_highlight_async_await = g:pymode_syntax_all
"let g:pymode_syntax_string_formatting = g:pymode_syntax_all
"let g:pymode_syntax_string_format = g:pymode_syntax_all
"let g:pymode_syntax_string_templates = g:pymode_syntax_all
"let g:pymode_syntax_doctests = g:pymode_syntax_all
"let g:pymode_syntax_builtin_objs = g:pymode_syntax_all
"let g:pymode_syntax_builtin_types = g:pymode_syntax_all
"let g:pymode_syntax_highlight_exceptions = g:pymode_syntax_all
"let g:pymode_syntax_docstrings = g:pymode_syntax_all
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
