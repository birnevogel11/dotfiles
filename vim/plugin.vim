" vim: ft=vim foldmethod=marker foldcolumn=1

" AutocompleteSelection: {{{
" 0: None
" 1: deoplete - vim/neovim
" 2: LanguageClient-neovim + deoplete.nvim - neovim only
let g:yen3_auto_complete_selection = 2
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
Plug 'tpope/vim-sensible'
Plug 'majutsushi/tagbar'
Plug 'pearofducks/ansible-vim'

" Generic
Plug 'Shougo/vimproc.vim', {'do': 'make'}
if has('nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

"" Edit
Plug 'w0rp/ale'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-sensible'
Plug 'terryma/vim-multiple-cursors'
Plug 'Yggdroot/indentLine'

Plug 'scrooloose/nerdcommenter'
Plug 'Raimondi/delimitMate'
Plug 'michaeljsmith/vim-indent-object'
Plug 'ntpeters/vim-better-whitespace'

"" Haskell
Plug 'ujihisa/neco-ghc', {'for': 'haskell'}
Plug 'ujihisa/repl.vim', {'for': 'haskell'}
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
Plug 'vim-scripts/haskell.vim', {'for': 'haskell'}

"" C/ Cpp
Plug 'rhysd/vim-clang-format'
Plug 'vim-scripts/cscope.vim'

"" Go
Plug 'fatih/vim-go'

"" Rust
Plug 'rust-lang/rust.vim'

"" Python
Plug 'yen3/vim-python-syntax'
Plug 'jeetsukumaran/vim-pythonsense'

"" JavaScript
Plug 'pangloss/vim-javascript'
Plug 'maksimr/vim-jsbeautify'

"" Vue.js
Plug 'pangloss/vim-javascript'
Plug 'posva/vim-vue'

"" Git
Plug 'tpope/vim-fugitive'
Plug 'int3/vim-extradite'
Plug 'junegunn/gv.vim', {'on': 'GV'}
Plug 'rhysd/git-messenger.vim'

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

Plug 'Shougo/neco-syntax'                     " language syntax
Plug 'zchee/deoplete-jedi'                    " Python
Plug 'davidhalter/jedi-vim'
Plug 'zchee/deoplete-go', { 'do': 'make' }    " Go
Plug 'deoplete-plugins/deoplete-docker'       " Dockerfile
Plug 'deoplete-plugins/deoplete-zsh'          " zsh
"Plug 'deoplete-plugins/deoplete-tag'          " tags
"Plug 'sebastianmarkow/deoplete-rust'          " Rust

"Plug 'Shougo/context_filetype.vim'
"Plug 'eagletmt/neco-ghc'                     " Haskell
"Plug 'carlitux/deoplete-ternjs'              " JavaScript
"Plug 'wokalski/autocomplete-flow'            " JavaScript
"
elseif g:yen3_auto_complete_selection == 2
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/neco-syntax'                     " language syntax
Plug 'zchee/deoplete-jedi'                    " Python
Plug 'davidhalter/jedi-vim'
Plug 'zchee/deoplete-go', { 'do': 'make' }    " Go
Plug 'deoplete-plugins/deoplete-docker'       " Dockerfile
Plug 'deoplete-plugins/deoplete-zsh'          " zsh
"Plug 'deoplete-plugins/deoplete-tag'          " tags

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


