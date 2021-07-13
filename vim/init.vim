" init: {{{
set runtimepath^=~/.vim runtimepath+=~/.vim/after
set viminfo+=n~/.nvim/tmpfiles/viminfo

let &packpath = &runtimepath
" }}}
" Lua config: {{{
lua require('yen3').setup()
" }}}
" vim: ft=vim foldmethod=marker foldcolumn=1 foldlevelstart=0
