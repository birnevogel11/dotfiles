let g:run_vim_uid = substitute(system("echo $UID"), '\n', '', 'g')
" init: {{{
set runtimepath^=~/.vim runtimepath+=~/.vim/after
set viminfo+=n~/.nvim/tmpfiles/viminfo

let &packpath = &runtimepath
" }}}
if g:run_vim_uid != "" && g:run_vim_uid != "0"
" Lua config: {{{
lua require('yen3').setup()
" }}}
endif
" vim: ft=vim foldmethod=marker foldcolumn=1 foldlevelstart=0
