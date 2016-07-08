" Autocomplete Select: {{{
" 0: None
" 1: YoucompleteMe + UltiSnips  - for vim
" 2: neocomplete + neosnippeta  - for vim >= 7.4
" 3: neocomplcache + neosnippet - for vim < 7.4  && vim >= 7.3
" 4: deoplete.nvim              - for nvim

" Default setting: no autocomplete 
let g:yen3_auto_complete_selet = 0

if has('nvim')
let g:yen3_auto_complete_selet =  4
else
let g:yen3_auto_complete_selet =  1
endif


"if has('nvim')
"let g:yen3_auto_complete_selet =  4
"else
    "if v:version >= 704
        "if has("lua")
            "let g:yen3_auto_complete_selet =  2
        "else
            "let g:yen3_auto_complete_selet =  3
        "endif
    "else
        "let g:yen3_auto_complete_selet =  0
    "endif
"endif

" Set automcomplete plugin combination manaually.
let g:yen3_auto_complete_selet = 0

" }}}
" Plugin: {{{
if &compatible
set nocompatible               " Be iMproved
endif

" Required:
set runtimepath^=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/dein'))

call dein#add('Shougo/dein.vim')
call dein#add('chriskempson/tomorrow-theme', {'rtp': 'vim'}) 

call dein#end()

" Required:
filetype plugin indent on

" If you want to install not installed plugins on startup.
" if dein#check_install()
"   call dein#install()
" endif


" vim: ft=vim foldmethod=marker foldcolumn=1
