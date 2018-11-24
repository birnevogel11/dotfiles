" vim: ft=vim foldmethod=marker foldcolumn=1

" AutocompleteSelection: {{{
" 0: None
" 1: deoplete - vim/neovim
" 2: lsp + deoplete.nvim - neovim only
let g:yen3_auto_complete_selection = 1
" }}}
" Plugin: {{{
filetype plugin indent on

if &compatible
    set nocompatible               " Be iMproved
endif

" Required:
call plug#begin('~/.vim/plugged')

"" Apperence
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim'}
Plug 'fneu/breezy'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mkitt/tabline.vim'

" Generic
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'Shougo/vimfiler.vim'

"" Edit
Plug 'vim-syntastic/syntastic'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-sensible'
Plug 'terryma/vim-multiple-cursors'

Plug 'scrooloose/nerdcommenter'
Plug 'Raimondi/delimitMate'
Plug 'michaeljsmith/vim-indent-object'
Plug 'ntpeters/vim-better-whitespace'

"" Syntax
Plug 'yen3/vim-python-syntax'
Plug 'posva/vim-vue'

"" Haskell
Plug 'ujihisa/neco-ghc', {'for': 'haskell'}
Plug 'ujihisa/repl.vim', {'for': 'haskell'}
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
Plug 'vim-scripts/haskell.vim', {'for': 'haskell'}

"" C/ Cpp
Plug 'rhysd/vim-clang-format'
Plug 'vim-scripts/cscope.vim'

"" Go
if has('nvim-0.3.1')
Plug 'fatih/vim-go'
endif

"" Python
"Plug 'python-mode/python-mode'

"" JavaScript
Plug 'pangloss/vim-javascript'
Plug 'maksimr/vim-jsbeautify'

"" Git
Plug 'tpope/vim-fugitive'
Plug 'int3/vim-extradite'
Plug 'junegunn/gv.vim', {'on': 'GV'}

"" Search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-outline'

"" Autocomplete
if g:yen3_auto_complete_selection == 1
if has('nvim')
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'Shougo/neco-syntax'      " language syntax
"Plug 'Shougo/context_filetype.vim'
Plug 'zchee/deoplete-jedi'     " Python
Plug 'davidhalter/jedi-vim'
"Plug 'Rip-Rip/clang_complete'  " C/C++
"Plug 'eagletmt/neco-ghc'      " Haskell
Plug 'zchee/deoplete-go', { 'do': 'make'} " Go
"Plug 'carlitux/deoplete-ternjs' " JavaScript
"Plug 'wokalski/autocomplete-flow' " JavaScript
elseif g:yen3_auto_complete_selection == 2
Plug 'autozimu/LanguageClient-neovim', {
\ 'branch': 'next',
\ 'do': 'bash install.sh',
\ }

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif " g:yen3_auto_complete_selection

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()

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


