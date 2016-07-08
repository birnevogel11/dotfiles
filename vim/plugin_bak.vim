if v:version >= 702

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
"" Let NeoBundle manage NeoBundle
if has('vim_starting')
  if !has('nvim')
      if &compatible
        set nocompatible               " Be iMproved
      endif
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

"" Recommended to install
"" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Shougo/vimfiler.vim'
NeoBundleLazy 'Shougo/vimshell.vim', { 'autoload' : {
      \ 'commands' : 'VimShell'
      \ }}
      

"" unite.vim and plugins
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/neoyank.vim'
NeoBundle 'thinca/vim-unite-history'
NeoBundle 'Shougo/unite-outline'
NeoBundleLazy 'tsukkee/unite-tag', { 'autoload' : {
      \ 'unite_sources' : 'tag'
      \ }}
NeoBundleLazy 'Shougo/unite-help', { 'autoload' : {
      \ 'unite_sources' : 'help'
      \ }}
NeoBundleLazy 'ujihisa/unite-launch', { 'autoload' : {
      \ 'unite_sources' : 'lanunch'
      \ }}
"NeoBundleLazy 'ujihisa/unite-locate', { 'autoload' : {
      "\ 'unite_sources' : 'locate',
      "\ }}
"NeoBundleLazy 'osyo-manga/unite-filetype', { 'autoload' : {
      "\ 'unite_sources' : 'filetype',
      "\ }}
"NeoBundleLazy 'Shougo/neobundle-vim-recipes', { 'autoload' : {
      "\ 'unite_sources' : 'neobundle',
      "\ }}

"" Edit
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-speeddating'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'Raimondi/delimitMate'
NeoBundle 'michaeljsmith/vim-indent-object'
NeoBundleLazy 'plasticboy/vim-markdown', { 'autoload' : {
      \ 'filetypes' : 'mkd'
      \ }}
NeoBundleLazy 'vim-scripts/DoxygenToolkit.vim', { 'autoload' : {
      \ 'filetypes' : 'cpp'
      \ }}
NeoBundleLazy 'rhysd/vim-clang-format', { 'autoload' : {
      \ 'filetypes' : 'cpp'
      \ }}


"if !has('nvim')
"NeoBundle 'google/vim-maktaba'
"NeoBundle 'google/vim-codefmt'
"NeoBundle 'google/vim-glaive'
"endif


"NeoBundleLazy 'Rykka/riv.vim', { 'autoload' : {
      "\ 'filetypes' : 'rst'
      "\ }}
"NeoBundleLazy 'mattn/emmet-vim', { 'autoload' : {
      "\ 'filetypes' : 'html'
      "\ }}
"NeoBundle 'Lokaltog/vim-easymotion'


"" IDE 
"NeoBundle 'majutsushi/tagbar'
NeoBundle 'MarcWeber/vim-addon-mw-utils'

"" Trace code
"NeoBundleLazy 'simplyzhao/cscope_maps.vim', { 'autoload' : {
            "\ 'filetypes' : 'c'
            "\ }}
            
"" LaTeX
"NeoBundleLazy 'LaTeX-Box-Team/LaTeX-Box', { 'autoload' : {
            "\ 'filetypes' : 'tex'
            "\ }}


"" Haskell
NeoBundleLazy 'ujihisa/neco-ghc', { 'autoload' : {
            \ 'filetypes' : 'haskell'
            \ }}
NeoBundleLazy 'ujihisa/repl.vim',  { 'autoload' : {
            \ 'filetypes' : 'haskell'
            \ }}
NeoBundleLazy 'eagletmt/ghcmod-vim',  { 'autoload' : {
            \ 'filetypes' : 'haskell'
            \ }}
"NeoBundleLazy 'raichoo/haskell-vim', {
            "\ 'filetypes': 'haskell'
            "\ }
"NeoBundleLazy 'lukerandall/haskellmode-vim', {
            "\ 'filetypes': 'haskell'
            "\ }
"NeoBundleLazy 'Twinside/vim-haskellConceal', {
            "\ 'filetypes': 'haskell'
            "\ }
"NeoBundleLazy 'frerich/unicode-haskell',  { 'autoload' : {
            "\ 'filetypes' : 'haskell'
            "\ }}
NeoBundleLazy 'vim-scripts/haskell.vim', {
            \ 'filetypes': 'haskell'
            \ }
"" C/ C++
"NeoBundle 'bbchung/clighter'
NeoBundle 'octol/vim-cpp-enhanced-highlight'

"" Python
NeoBundle 'klen/python-mode'
NeoBundle 'xitianfz/vim-python-syntax', { 'autoload' : {
            \ 'filetypes' : 'python'
            \ }}

"" Scala
NeoBundle 'derekwyatt/vim-scala', { 'autoload' : {
            \ 'filetypes' : 'scala'
            \ }}
NeoBundle 'derekwyatt/vim-sbt', { 'autoload' : {
            \ 'filetypes' : 'scala'
            \ }}


"" JavaScript
"NeoBundleLazy 'jelera/vim-javascript-syntax'
"NeoBundleLazy 'pangloss/vim-javascript'
"NeoBundle 'mxw/vim-jsx'

"" Rust
"NeoBundle 'rust-lang/rust.vim'

"" Cool
"NeoBundle "vim-scripts/cool.vim"

"" Git/ Svn
""" Git
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'int3/vim-extradite'
NeoBundleLazy 'gregsexton/gitv', { 'autoload' : {
      \ 'commands' : 'Gitv'
      \ }}

""" Svn
NeoBundle 'juneedahamed/vc.vim'

"" Syntax check
NeoBundle 'scrooloose/syntastic'
"NeoBundle 'Twinside/vim-cuteErrorMarker'

"" Syntax
NeoBundle 'slurps-mad-rips/cmake.vim'

"" Apperance 
NeoBundle 'chriskempson/tomorrow-theme', {'rtp': 'vim'}
NeoBundle 'vim-airline/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'
"NeoBundle 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
NeoBundle 'mkitt/tabline.vim'
"NeoBundleLazy 'ap/vim-css-color', { 'autoload' : {
      "\ 'filetypes' : 'css'
      "\ }}
"NeoBundleLazy 'vim-scripts/DirDiff.vim', { 'autoload' : {
      "\  'commands': 'DirDiff' 
      "\ }}
      "
"" Autocomplete
if g:yen3_auto_complete_selet == 1
" Track the engine.
NeoBundle 'Valloric/YouCompleteMe', {
     \ 'build' : {
     \     'mac' : 'python install.py --clang-completer --system-libclang',
     \     'unix' : 'python install.py --clang-completer --system-libclang',
     \    }
     \ }
NeoBundle 'rdnetto/YCM-Generator'
NeoBundle 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
NeoBundle 'honza/vim-snippets'
endif

if g:yen3_auto_complete_selet == 2
NeoBundle 'Shougo/neocomplete'
NeoBundle 'osyo-manga/vim-reunions'
NeoBundle 'osyo-manga/vim-marching'
endif

if g:yen3_auto_complete_selet == 3
NeoBundle 'Shougo/neocomplcache.vim'
endif

if g:yen3_auto_complete_selet == 2 || g:yen3_auto_complete_selet == 3
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
endif

if g:yen3_auto_complete_selet == 4
NeoBundle 'Shougo/deoplete.nvim'
endif


" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
" }}}
" Autocomplete: {{{
source ~/.vim/vim/plugin/autocomplete.vim
" }}}
" Unite: {{{
source ~/.vim/vim/plugin/unite.vim
" }}}
" Misc: {{{
source ~/.vim/vim/plugin/misc.vim
" }}}
endif " if v:version >= 702

" vim: ft=vim foldmethod=marker foldcolumn=1
