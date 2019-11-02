" vim: ft=vim foldmethod=marker foldcolumn=1 foldlevelstart=0

" zM: foldall
" General: {{{
" remapping the leader key
let mapleader = ","
" }}}
" Source_path_setting: {{{
source ~/.config/nvim/vim/plugin.vim
source ~/.config/nvim/vim/general.vim
" }}}
" GUI Setting: {{{
source ~/.config/nvim/vim/gui.vim
" }}}
" NVIM Setting: {{{
if has('nvim')
set viminfo+=n~/.nvim/tmpfiles/viminfo
endif
" }}}
