" vim: ft=vim foldmethod=marker foldcolumn=1 foldlevelstart=0

" zM: foldall
" Leader Key: {{{
" remapping the leader key
let mapleader = ","
" }}}
" AutocompleteSelection: {{{
" 0: Disable
" 1: LanguageClient-neovim + deoplete.nvim - neovim only
if has('mac') || has('nvim')
  let g:yen3_auto_complete_selection = 1
else
  let g:yen3_auto_complete_selection = 0
endif
let g:yen3_auto_complete_enable_lsp = 0
" }}}
" Plugin: {{{
if &compatible
  set nocompatible
endif

" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('wsdjeg/dein-ui.vim')

  "" Apperence
  call dein#add('chriskempson/tomorrow-theme', {'rtp': 'vim'})
  call dein#add('petobens/colorish')
  call dein#add('fneu/breezy')
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('mkitt/tabline.vim')
  call dein#add('tpope/vim-sensible')
  call dein#add('majutsushi/tagbar')
  call dein#add('pearofducks/ansible-vim')

  " Generic
  call dein#add('Shougo/vimproc.vim', {'build': 'make'})
  call dein#add('Shougo/defx.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  call dein#add('kristijanhusak/defx-git')
  if has('mac')
    call dein#add('rizzatti/dash.vim')
  endif

  "" Edit
  call dein#add('w0rp/ale')
  call dein#add('MarcWeber/vim-addon-mw-utils')
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-endwise')
  call dein#add('tpope/vim-speeddating')
  call dein#add('tpope/vim-sensible')
  call dein#add('terryma/vim-multiple-cursors')
  call dein#add('Yggdroot/indentLine')

  call dein#add('scrooloose/nerdcommenter')
  call dein#add('Raimondi/delimitMate')
  call dein#add('michaeljsmith/vim-indent-object')
  call dein#add('ntpeters/vim-better-whitespace')

  "" Haskell
  call dein#add('ujihisa/neco-ghc', {'on_ft': 'haskell'})
  call dein#add('ujihisa/repl.vim', {'on_ft': 'haskell'})
  call dein#add('eagletmt/ghcmod-vim', {'on_ft': 'haskell'})
  call dein#add('vim-scripts/haskell.vim', {'on_ft': 'haskell'})

  "" C/ Cpp
  call dein#add('rhysd/vim-clang-format')
  call dein#add('vim-scripts/cscope.vim')

  "" Go
  call dein#add('fatih/vim-go', {'on_ft': 'go'})

  "" Rust
  call dein#add( 'rust-lang/rust.vim')

  "" Python
  call dein#add('yen3/vim-python-syntax')
  call dein#add('ambv/black', {'on_ft': 'python' })

  "" JavaScript
  " call dein#add('pangloss/vim-javascript')
  " call dein#add('maksimr/vim-jsbeautify')

  "" Vue.js
  " call dein#add('pangloss/vim-javascript')
  " call dein#add('posva/vim-vue')

  "" Git
  call dein#add('tpope/vim-fugitive')
  call dein#add('int3/vim-extradite')
  call dein#add('junegunn/gv.vim', {'on_cmd': 'GV'})
  call dein#add('rhysd/git-messenger.vim', {'on_cmd': 'GitMessenger'})

  if !empty('$TMUX')
    " call dein#add('christoomey/vim-tmux-navigator')
    call dein#add('wellle/tmux-complete.vim')
    call dein#add('tmux-plugins/vim-tmux-focus-events')
  endif

  "" Search
  call dein#add('junegunn/fzf', {'build': './install --all', 'merged': 0})
  call dein#add('junegunn/fzf.vim', {'depends': 'fzf'})
  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/unite-outline')

  if g:yen3_auto_complete_selection == 1
    call dein#add('Shougo/deoplete.nvim')
    call dein#add('Shougo/neco-syntax')                                        " language syntax
    call dein#add('zchee/deoplete-jedi', {'on_ft': 'python'})                  " Python
    call dein#add('davidhalter/jedi-vim', {'on_ft': 'python'})
    call dein#add('zchee/deoplete-go', {'do': 'make', 'on_ft': 'go'})          " Go
    call dein#add('deoplete-plugins/deoplete-docker', {'on_ft': 'dockerfile'}) " Dockerfile
    call dein#add('deoplete-plugins/deoplete-zsh', {'on_ft': 'zsh'})           " zsh
    if g:yen3_auto_complete_enable_lsp == 1
      call dein#add('autozimu/LanguageClient-neovim', {'rev': 'next', 'build': 'bash install.sh', 'merged': 0})
    endif

    "call dein#add('deoplete-plugins/deoplete-tag')        " tags
    "call dein#add('sebastianmarkow/deoplete-rust')        " Rust

    "call dein#add('Shougo/context_filetype.vim')
    "call dein#add('eagletmt/neco-ghc')                    " Haskell
    "call dein#add('carlitux/deoplete-ternjs')             " JavaScript
    "call dein#add('wokalski/autocomplete-flow' )          " JavaScript
  endif

  call dein#add('SirVer/ultisnips')
  call dein#add('honza/vim-snippets')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable
" }}}
" Plugin autocomplete: {{{
source ~/.config/nvim/vim/plugin/autocomplete.vim
" }}}
" Plugin search: {{{
source ~/.config/nvim/vim/plugin/search.vim
" }}}
" Plugin misc: {{{
source ~/.config/nvim/vim/plugin/misc.vim
" }}}
" General setting: {{{
source ~/.config/nvim/vim/general.vim
" }}}
