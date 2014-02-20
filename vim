" Yen3's vimrc

" zM: foldall
if v:version >= 700
" Lite Vim: {{{
"let g:yen3_lite_vim_setting = 1
" }}}
" Source_path_setting: {{{
if has('win32')
    set runtimepath+=~/_vim/

    source ~/_vim/vimrc/plugin.vim
    source ~/_vim/vimrc/general.vim
    source ~/_vim/vimrc/win.vim
else
    source ~/.vim/vimrc/plugin.vim
    source ~/.vim/vimrc/general.vim
    source ~/.vim/vimrc/mac.vim
endif
" }}}
" GUI Setting: {{{
if has("gui_running")   
    source ~/.vim/vimrc/gui.vim
endif
" }}}
endif "if v:version >= 700

" vim: ft=vim foldmethod=marker foldcolumn=1 foldlevelstart=0

