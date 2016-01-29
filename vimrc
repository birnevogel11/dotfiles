" Yen3's vimrc
" zM: foldall
" General: {{{
" remapping the leader key
let mapleader = ","
" }}}
" Source_path_setting: {{{
if v:version >= 700
    source ~/.vim/vim/plugin.vim
    source ~/.vim/vim/general.vim
    source ~/.vim/vim/macosx.vim
endif "if v:version >= 700
" }}}
" GUI Setting: {{{
if v:version >= 700
    source ~/.vim/vim/gui.vim
endif "if v:version >= 700
" }}}
if has('nvim')
set viminfo+=n~/.nvim/tmpfiles/viminfo
endif

" vim: ft=vim foldmethod=marker foldcolumn=1 foldlevelstart=0

