" Plugin Select: {{{
" Autocomplete Select: {{{
" 0: None
" 1: YoucompleteMe + UltiSnips  - for vim
" 2: neocomplete + neosnippeta  - for vim >= 7.4
" 3: deoplete.nvim + UltiSnips  - for nvim
if has("mac")
let g:yen3_auto_complete_select = 1
else
let g:yen3_auto_complete_select = 0
endif

" }}}
" Search Plugin Select: {{{
" 0: None
" 1: Unite 
" 2: fzf
" 3: fzf + unite-outline
let g:yen3_search_plugin_select = 1
" }}}
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
call dein#add('sheerun/vim-polyglot')

"" Edit
call dein#add('scrooloose/syntastic')
call dein#add('MarcWeber/vim-addon-mw-utils')
call dein#add('tpope/vim-surround')
call dein#add('tpope/vim-endwise')
call dein#add('tpope/vim-speeddating')
call dein#add('tpope/vim-sensible')

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

"" Python
call dein#add('klen/python-mode', {'on_ft': 'python'})
call dein#add('xitianfz/vim-python-syntax', {'on_ft': 'python'})

"" Git
call dein#add('tpope/vim-fugitive')
call dein#add('int3/vim-extradite')
call dein#add('junegunn/gv.vim', {'on_cmd': 'GV'})

"" Search {{{
if g:yen3_search_plugin_select== 1
""" Unite
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/neoyank.vim')
call dein#add('thinca/vim-unite-history')
call dein#add('Shougo/unite-outline')

elseif g:yen3_search_plugin_select == 2
""" FZF
call dein#add('junegunn/fzf', {'build': './install', 'merged': 0})
call dein#add('junegunn/fzf.vim')

elseif g:yen3_search_plugin_select == 3
call dein#add('junegunn/fzf', {'build': './install', 'merged': 0})
call dein#add('junegunn/fzf.vim')
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/unite-outline')

endif
" }}}
"" Autocomplete {{{
if g:yen3_auto_complete_select == 1
call dein#add('Valloric/YouCompleteMe', {'build': './install.py --clang-completer', 'merged': 0})
call dein#add('rdnetto/YCM-Generator')
call dein#add('SirVer/ultisnips')
call dein#add('honza/vim-snippets')
endif

if g:yen3_auto_complete_select == 2
call dein#add('Shougo/neocomplete', {'merged': 0})
call dein#add('osyo-manga/vim-reunions', {'merged': 0})
call dein#add('osyo-manga/vim-marching', {'merged': 0})
call dein#add('Shougo/neosnippet', {'merged': 0})
call dein#add('Shougo/neosnippet-snippets', {'merged': 0})
endif

if g:yen3_auto_complete_select == 3
call dein#add('Shougo/deoplete.nvim')
call dein#add('zchee/deoplete-clang')
call dein#add('zchee/deoplete-jedi')
call dein#add('SirVer/ultisnips')
call dein#add('honza/vim-snippets')
endif

" }}}

call dein#end()

" Required:
filetype plugin indent on

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" }}}
" Autocomplete: {{{
source ~/.vim/vim/plugin/autocomplete.vim
" }}}
" Search: {{{
source ~/.vim/vim/plugin/search.vim
" }}}
" Misc: {{{
source ~/.vim/vim/plugin/misc.vim
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
