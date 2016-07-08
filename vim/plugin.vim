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

"" Apperence
call dein#add('chriskempson/tomorrow-theme', {'rtp': 'vim'}) 
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
call dein#add('mkitt/tabline.vim')

"" Generic
call dein#add('Shougo/vimproc.vim', {'build': 'make'})
call dein#add('Shougo/vimfiler.vim')

"" Unite
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/neoyank.vim')
call dein#add('thinca/vim-unite-history')
call dein#add('Shougo/unite-outline')

"" Edit
call dein#add('scrooloose/syntastic')
call dein#add('MarcWeber/vim-addon-mw-utils')
call dein#add('tpope/vim-surround')
call dein#add('tpope/vim-endwise')
call dein#add('tpope/vim-speeddating')
call dein#add('scrooloose/nerdcommenter')
call dein#add('Raimondi/delimitMate')
call dein#add('michaeljsmith/vim-indent-object')
call dein#add('plasticboy/vim-markdown', {'on_ft': 'mkd'})
call dein#add('vim-scripts/DoxygenToolkit.vim', {'on_ft': 'cpp'})

"" Haskell
call dein#add('ujihisa/neco-ghc', {'on_ft': 'haskell'})
call dein#add('ujihisa/repl.vim', {'on_ft': 'haskell'})
call dein#add('eagletmt/ghcmod-vim', {'on_ft': 'haskell'})
call dein#add('vim-scripts/haskell.vim', {'on_ft': 'haskell'})

"" C/ Cpp 
call dein#add('rhysd/vim-clang-format', {'on_ft': 'cpp'})
call dein#add('octol/vim-cpp-enhanced-highlight', {'on_ft': 'cpp'})

"" Python
call dein#add('klen/python-mode', {'on_ft': 'python'})
call dein#add('xitianfz/vim-python-syntax', {'on_ft': 'python'})

"" Git
call dein#add('tpope/vim-fugitive')
call dein#add('int3/vim-extradite')
call dein#add('gregsexton/gitv', {'on_cmd': 'Gitv'})




call dein#end()

" Required:
filetype plugin indent on

" If you want to install not installed plugins on startup.
" if dein#check_install()
"   call dein#install()
" endif


" vim: ft=vim foldmethod=marker foldcolumn=1
