" zM: foldall
" Preamble {{{
let s:is_mac = (has('mac') || has('macunix') || has('gui_macvim')
            \ || system('uname') =~? '^darwin')
let s:is_linux = !s:is_mac

if !has('nvim')
  let $DOTVIM = expand('$HOME/.vim')
else
  let $DOTVIM = expand('$HOME/.config/nvim')
endif

if !has('nvim')
  set viminfo+=n~/.local/share/vim/viminfo
endif

" remapping the leader key
let g:mapleader = ","
" }}}
" Plugin Selection: {{{
" 0: Disable
" 1: deoplete.nvim + LanguageClient-neovim
" 2: deoplete.nvim + nvim-lsp (WIP)
let g:yen3_auto_complete_selection = 2
" 0: Disable
" 1: Enable LanguageClient-neovim - neovim only
let g:yen3_auto_complete_enable_lsp = 1
" 0: Disable
" 1: Enable dev-icons
let g:yen3_enable_dev_icons = 0
" 0: Disable
" 1: Fzf + Unite outline
" 2: Denite
let g:yen3_search_selection = 2
" }}}
" Plugin: {{{
if &compatible
  set nocompatible
endif

call plug#begin('~/.cache/vim-plug')

"" Apperence
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim'}
Plug 'petobens/colorish'
Plug 'joshdick/onedark.vim'
Plug 'fneu/breezy'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mkitt/tabline.vim'
Plug 'tpope/vim-sensible'
Plug 'majutsushi/tagbar'
Plug 'tenfyzhong/tagbar-makefile.vim'
Plug 'pearofducks/ansible-vim'
Plug 'neomake/neomake'
Plug 'arcticicestudio/nord-vim'
Plug 'lifepillar/vim-solarized8'


" Generic
Plug 'Shougo/vimproc.vim', {'do': 'make'}
if exists(':tnoremap')
  Plug 'kassio/neoterm'
endif
Plug 'Shougo/defx.nvim'
Plug 'kristijanhusak/defx-git'
Plug 'lambdalisue/fern.vim'
if g:yen3_enable_dev_icons == 1
  Plug 'kristijanhusak/defx-icons'
endif
Plug 'aymericbeaumet/vim-symlink'
if has('mac')
  Plug 'rizzatti/dash.vim'
endif
Plug 'embear/vim-localvimrc'
Plug 'puremourning/vimspector'
let g:polyglot_disabled = ['cpp', 'c', 'python']
Plug 'sheerun/vim-polyglot'

"" Edit
Plug 'dense-analysis/ale'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'Yggdroot/indentLine'

Plug 'scrooloose/nerdcommenter'
Plug 'Raimondi/delimitMate'
Plug 'michaeljsmith/vim-indent-object'
Plug 'ntpeters/vim-better-whitespace'
Plug 'sbdchd/neoformat'

"" Haskell
Plug 'ujihisa/neco-ghc', {'for': 'haskell'}
Plug 'ujihisa/repl.vim', {'for': 'haskell'}
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
Plug 'vim-scripts/haskell.vim', {'for': 'haskell'}

"" LaTeX
Plug 'lervag/vimtex', {'for': 'tex'}

"" C/Cpp
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rhysd/vim-clang-format'
Plug 'vim-scripts/cscope.vim'

"" Go
Plug 'fatih/vim-go', {'for': 'go'}

"" Rust
Plug 'rust-lang/rust.vim', {'for': 'rust'}

"" Markdown
Plug 'plasticboy/vim-markdown', {'for' : 'markdown'}
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

"" TOML
Plug 'cespare/vim-toml', {'for': 'toml'}

"" Python
Plug 'vim-python/python-syntax', {'for' : 'python'}
Plug 'ambv/black', {'for': 'python' }

"" Html
Plug 'mattn/emmet-vim', {'for' : 'html'}
Plug 'vim-scripts/HTML-AutoCloseTag'

"" Git
Plug 'tpope/vim-fugitive'
Plug 'int3/vim-extradite', {'on': 'Extradite'}
Plug 'junegunn/gv.vim', {'on': 'GV'}
Plug 'rhysd/git-messenger.vim', {'on': 'GitMessenger'}
Plug 'mhinz/vim-signify'
Plug 'lambdalisue/gina.vim'

"" COOL
Plug 'vim-scripts/cool.vim', {'for': 'cool'}

"" Tmux
if !empty('$TMUX')
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'wellle/tmux-complete.vim'
  Plug 'tmux-plugins/vim-tmux-focus-events'
endif

"" Search
if g:yen3_search_selection == 1
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'Shougo/unite.vim'
  Plug 'Shougo/unite-outline'
elseif g:yen3_search_selection == 2
  " Denite
  Plug 'Shougo/denite.nvim'
  Plug 'chemzqm/denite-git'
  Plug 'neoclide/denite-extra'
  Plug 'raghur/fruzzy'
  Plug 'Shougo/neomru.vim'
  Plug 'Shougo/neoyank.vim'
  Plug 'rafi/vim-denite-z'
  Plug 'kmnk/denite-dirmark'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'Shougo/unite.vim'
  Plug 'Shougo/unite-outline'
endif

"" Snippet
Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

"" Autocomplete
if g:yen3_auto_complete_selection == 1
  Plug 'Shougo/deoplete.nvim'
  if !has('nvim')
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
  Plug 'Shougo/neco-syntax'                                        " language syntax
  Plug 'zchee/deoplete-jedi', {'on_ft': 'python'}                  " Python
  Plug 'davidhalter/jedi-vim', {'on_ft': 'python'}
  Plug 'deoplete-plugins/deoplete-docker', {'on_ft': 'dockerfile'} " Dockerfile
  Plug 'deoplete-plugins/deoplete-asm'                             " Intel asm
  Plug 'deoplete-plugins/deoplete-zsh', {'on_ft': 'zsh'}           " zsh
  Plug 'Shougo/neco-vim'                                           " Vim
  if g:yen3_auto_complete_enable_lsp == 1
    if has("mac")
      Plug 'autozimu/LanguageClient-neovim', {
            \ 'tag': 'binary-0.1.154-x86_64-apple-darwin',
            \ 'do': 'bash install.sh',
            \ }
    else
      Plug 'autozimu/LanguageClient-neovim', {
            \ 'tag': 'binary-0.1.154-x86_64-unknown-linux-musl',
            \ 'do': 'bash install.sh',
            \ }
    endif
  endif

  " Plug 'deoplete-plugins/deoplete-tag'        " tags
  " Plug 'sebastianmarkow/deoplete-rust'        " Rust

  " Plug 'Shougo/context_filetype.vim'
  " Plug 'eagletmt/neco-ghc'                    " Haskell
  " Plug 'carlitux/deoplete-ternjs'             " JavaScript
  " Plug 'wokalski/autocomplete-flow'           " JavaScript
elseif g:yen3_auto_complete_selection == 2
  Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}

  Plug 'Shougo/deoplete-lsp'
  Plug 'neovim/nvim-lsp'
  Plug 'haorenW1025/diagnostic-nvim'

  Plug 'Shougo/neco-syntax'                                        " language syntax
  Plug 'zchee/deoplete-jedi', {'on_ft': 'python'}                  " Python
  Plug 'davidhalter/jedi-vim', {'on_ft': 'python'}
  Plug 'deoplete-plugins/deoplete-asm'                             " Intel asm
  Plug 'deoplete-plugins/deoplete-docker', {'on_ft': 'dockerfile'} " Dockerfile
  Plug 'deoplete-plugins/deoplete-zsh', {'on_ft': 'zsh'}           " zsh
  Plug 'Shougo/neco-vim'                                           " Vim

  " Plug 'deoplete-plugins/deoplete-tag'        " tags
  " Plug 'sebastianmarkow/deoplete-rust'        " Rust

  " Plug 'Shougo/context_filetype.vim'
  " Plug 'eagletmt/neco-ghc'                    " Haskell
  " Plug 'carlitux/deoplete-ternjs'             " JavaScript
  " Plug 'wokalski/autocomplete-flow'           " JavaScript
endif

if has('nvim')
  " ref: https://github.com/petobens/dotfiles/blob/master/vim/init.vim#L190
  " This basically fixes visual block pasting
  " https://github.com/neovim/neovim/issues/1822#issuecomment-233152833
  Plug 'bfredl/nvim-miniyank'
endif

if g:yen3_enable_dev_icons == 1
  " Devicons (load this last!)
  Plug 'ryanoasis/vim-devicons'
endif

call plug#end()
" }}}
" Plugin setting: {{{
source ~/.config/nvim/vim/plugin.vim
" }}}
" Plugin autocomplete: {{{
source ~/.config/nvim/vim/autocomplete.vim
" }}}
" Plugin search: {{{
source ~/.config/nvim/vim/search.vim
" }}}
" General setting: {{{
source ~/.config/nvim/vim/general.vim
" }}}
" Local setting {{{
if filereadable($HOME . "/.vimrc_local")
  source ~/.vimrc_local
endif
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1 foldlevelstart=0
