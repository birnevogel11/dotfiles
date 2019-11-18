" vim: ft=vim foldmethod=marker foldcolumn=1 foldlevelstart=0

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

if s:is_mac
  let $CACHE = expand('$HOME/.cache/yen3/darwin')
else
  let $CACHE = expand('$HOME/.cache/yen3/ubuntu')
endif

" remapping the leader key
let g:mapleader = ","
" }}}
" Plugin Selection: {{{
" 0: Disable
" 1: deoplete.nvim
if has('mac') || has('nvim')
  let g:yen3_auto_complete_selection = 1
else
  let g:yen3_auto_complete_selection = 0
endif
" 0: Disable
" 1: Enable LanguageClient-neovim - neovim only
let g:yen3_auto_complete_enable_lsp = 1
" 0: Disable
" 1: Enable dev-icons
let g:yen3_enable_dev_icons = 0
" 0: Disable
" 1: Fzf + Unite outline
" 2: Denite - WIP
let g:yen3_search_selection = 1
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
  if exists(':tnoremap')
    call dein#add('kassio/neoterm')
  endif
  call dein#add('Shougo/defx.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  if g:yen3_enable_dev_icons == 1
    call dein#add('kristijanhusak/defx-git')
    call dein#add('kristijanhusak/defx-icons')
  endif
  call dein#add('aymericbeaumet/vim-symlink')
  if has('mac')
    call dein#add('rizzatti/dash.vim')
  endif
  call dein#add('simnalamburt/vim-mundo', {'on_cmd' : 'MundoToggle'})

  "" Edit
  call dein#add('w0rp/ale')
  call dein#add('MarcWeber/vim-addon-mw-utils')
  call dein#add('tpope/vim-abolish')
  call dein#add('tpope/vim-dispatch')
  call dein#add('tpope/vim-endwise')
  call dein#add('tpope/vim-rhubarb')
  call dein#add('tpope/vim-sensible')
  call dein#add('tpope/vim-speeddating')
  call dein#add('tpope/vim-surround')
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

  "" LaTeX
  call dein#add('lervag/vimtex', {'on_ft' : ['tex', 'bib']})

  "" C/ Cpp
  call dein#add('rhysd/vim-clang-format')
  call dein#add('vim-scripts/cscope.vim')

  "" Go
  call dein#add('fatih/vim-go', {'on_ft': 'go'})

  "" Rust
  call dein#add('rust-lang/rust.vim', {'on_ft': 'rust'})

  "" Markdown
  call dein#add('plasticboy/vim-markdown', {'on_ft' : 'markdown'})

  "" TOML
  call dein#add('cespare/vim-toml', {'on_ft': 'toml'})

  "" Python
  call dein#add('yen3/vim-python-syntax')
  call dein#add('ambv/black', {'on_ft': 'python' })

  "" Git
  call dein#add('tpope/vim-fugitive')
  call dein#add('int3/vim-extradite')
  call dein#add('junegunn/gv.vim', {'on_cmd': 'GV'})
  call dein#add('rhysd/git-messenger.vim', {'on_cmd': 'GitMessenger'})

  "" Tmux
  if !empty('$TMUX')
    call dein#add('christoomey/vim-tmux-navigator')
    call dein#add('wellle/tmux-complete.vim')
    call dein#add('tmux-plugins/vim-tmux-focus-events')
  endif

  "" Search
  if g:yen3_search_selection == 1
    call dein#add('junegunn/fzf', {'build': './install --all', 'merged': 0})
    call dein#add('junegunn/fzf.vim', {'depends': 'fzf', 'merged': 0})
    call dein#add('Shougo/unite.vim', {'merged': 0})
    call dein#add('Shougo/unite-outline', {'merged': 0})
  elseif g:yen3_search_selection == 2
    " WIP
  endif

  "" Snippet
  call dein#add('SirVer/ultisnips')
  "rcall dein#add('honza/vim-snippets')

  "" Autocomplete
  if g:yen3_auto_complete_selection == 1
    call dein#add('Shougo/deoplete.nvim')
    if !has('nvim')
      call dein#add('roxma/nvim-yarp')
      call dein#add('roxma/vim-hug-neovim-rpc')
    endif
    call dein#add('Shougo/neco-syntax')                                        " language syntax
    call dein#add('zchee/deoplete-jedi', {'on_ft': 'python'})                  " Python
    call dein#add('davidhalter/jedi-vim', {'on_ft': 'python'})
    call dein#add('zchee/deoplete-go', {'do': 'make', 'on_ft': 'go'})          " Go
    call dein#add('deoplete-plugins/deoplete-docker', {'on_ft': 'dockerfile'}) " Dockerfile
    call dein#add('deoplete-plugins/deoplete-zsh', {'on_ft': 'zsh'})           " zsh
    call dein#add('Shougo/neco-vim')                                           " Vim
    if g:yen3_auto_complete_enable_lsp == 1
      call dein#add('autozimu/LanguageClient-neovim', {
            \ 'rev': 'next',
            \ 'build': 'bash install.sh',
            \ 'merged': 0}
            \ )
    endif

    "call dein#add('deoplete-plugins/deoplete-tag')        " tags
    "call dein#add('sebastianmarkow/deoplete-rust')        " Rust

    "call dein#add('Shougo/context_filetype.vim')
    "call dein#add('eagletmt/neco-ghc')                    " Haskell
    "call dein#add('carlitux/deoplete-ternjs')             " JavaScript
    "call dein#add('wokalski/autocomplete-flow' )          " JavaScript
  endif

  if has('nvim')
    " ref: https://github.com/petobens/dotfiles/blob/master/vim/init.vim#L190
    " This basically fixes visual block pasting
    " https://github.com/neovim/neovim/issues/1822#issuecomment-233152833
    call dein#add('bfredl/nvim-miniyank')
  endif

  if g:yen3_enable_dev_icons == 1
    " Devicons (load this last!)
    call dein#add('ryanoasis/vim-devicons')
  endif

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

" Check if all plugins are installed and ask to install those that are not
" installed
if dein#check_install()
  call dein#install()
endif
" }}}
" Plugin autocomplete: {{{
source ~/.config/nvim/vim/autocomplete.vim
" }}}
" Plugin search: {{{
source ~/.config/nvim/vim/search.vim
" }}}
" Plugin misc: {{{
source ~/.config/nvim/vim/misc.vim
" }}}
" General setting: {{{
source ~/.config/nvim/vim/general.vim
" }}}
" Undo setting {{{
" Persistent undo (i.e vim remembers undo actions even if file is closed and
" reopened)
set undofile
set undolevels=1000   " Maximum number of changes that can be undone
set undoreload=10000  " Maximum number lines to save for undo on a buffer reload

set undodir=$CACHE/tmp/undo/

" Make those directories (and intermediate ones) if they don't exist
function! s:MakeDirIfNoExists(path)
    if !isdirectory(expand(a:path))
        call mkdir(expand(a:path), 'p')
    endif
endfunction

silent! call s:MakeDirIfNoExists(&undodir)
" }}}
