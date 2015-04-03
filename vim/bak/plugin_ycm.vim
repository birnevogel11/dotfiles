" General: {{{
set nocompatible
filetype off
" }}}

if v:version >= 702

" Leader_key_mapping:{{{
let mapleader = ","
" }}}
" Plugin: {{{
"" Let NeoBundle manage NeoBundle

set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

"" Recommended to install
"" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }

"" unite.vim and plugins
NeoBundleLazy 'Shougo/unite.vim', { 'autoload' : {
      \ 'commands' : 'Unite'
      \ }}
NeoBundleLazy 'Shougo/neomru.vim', { 'autoload' : {
      \ 'unite_sources' : 'file_mru'
      \ }}
NeoBundleLazy 'tsukkee/unite-tag', { 'autoload' : {
      \ 'unite_sources' : 'tag'
      \ }}
NeoBundleLazy 'Shougo/unite-outline', { 'autoload' : {
      \ 'unite_sources' : 'outline'
      \ }}
NeoBundleLazy 'Shougo/unite-help', { 'autoload' : {
      \ 'unite_sources' : 'help'
      \ }}
NeoBundleLazy 'ujihisa/unite-launch', { 'autoload' : {
      \ 'unite_sources' : 'lanunch'
      \ }}
NeoBundleLazy 'ujihisa/unite-locate', { 'autoload' : {
      \ 'unite_sources' : 'locate',
      \ }}
NeoBundleLazy 'osyo-manga/unite-filetype', { 'autoload' : {
      \ 'unite_sources' : 'filetype',
      \ }}
NeoBundleLazy 'thinca/vim-unite-history', { 'autoload' : {
      \ 'unite_sources' : 'history',
      \ }}
NeoBundleLazy 'Shougo/neobundle-vim-recipes', { 'autoload' : {
      \ 'unite_sources' : 'neobundle',
      \ }}
NeoBundleLazy 'thinca/vim-qfreplace', { 'autoload' : {
      \ 'unite_sources' : 'grep',
      \ }}
NeoBundle "Shougo/vimfiler.vim"

"" Edit
NeoBundle "tpope/vim-surround"
NeoBundle "tpope/vim-endwise"
NeoBundle "tpope/vim-speeddating"
NeoBundle "scrooloose/nerdcommenter"
NeoBundle "Raimondi/delimitMate"
NeoBundleLazy 'plasticboy/vim-markdown', { 'autoload' : {
      \ 'filetypes' : 'mkd'
      \ }}
NeoBundleLazy "Rykka/riv.vim", { 'autoload' : {
      \ 'filetypes' : 'rst'
      \ }}
NeoBundleLazy 'mattn/emmet-vim', { 'autoload' : {
      \ 'filetypes' : 'html'
      \ }}
NeoBundle "michaeljsmith/vim-indent-object"
NeoBundleLazy "vim-scripts/DoxygenToolkit.vim", { 'autoload' : {
      \ 'filetypes' : 'cpp'
      \ }}
NeoBundle 'Lokaltog/vim-easymotion'
"NeoBundle "godlygeek/tabular"


"" IDE 
"NeoBundle 'scrooloose/nerdtree'
"NeoBundle 'majutsushi/tagbar'
NeoBundle "MarcWeber/vim-addon-mw-utils"

"" Trace code
NeoBundleLazy "simplyzhao/cscope_maps.vim", { 'autoload' : {
            \ 'filetypes' : 'c'
            \ }}
"NeoBundleLazy 'vim-scripts/CCTree' , { 'autoload' : {
            "\ 'filetypes' : 'c'
            "\ }}

"" Haskell
NeoBundleLazy 'vim-scripts/haskell.vim', {
            \ 'filetypes': 'haskell'
            \ }
"NeoBundleLazy "lukerandall/haskellmode-vim", {
            "\ 'filetypes': 'haskell'
            "\ }
NeoBundleLazy 'ujihisa/neco-ghc', { 'autoload' : {
            \ 'filetypes' : 'haskell'
            \ }}
"NeoBundleLazy "Twinside/vim-haskellConceal", {
            "\ 'filetypes': 'haskell'
            "\ }
NeoBundleLazy 'ujihisa/repl.vim',  { 'autoload' : {
            \ 'filetypes' : 'haskell'
            \ }}
"NeoBundleLazy 'frerich/unicode-haskell',  { 'autoload' : {
            "\ 'filetypes' : 'haskell'
            "\ }}

"" Python
NeoBundleLazy 'klen/python-mode', { 'autoload' : {
            \ 'filetypes' : 'python'
            \ }}
"NeoBundleLazy 'davidhalter/jedi-vim', { 'autoload' : {
            "\ 'filetypes' : 'python'
            "\ }}
NeoBundle 'xitianfz/vim-python-syntax', { 'autoload' : {
            \ 'filetypes' : 'python'
            \ }}

"" Scala
NeoBundle 'derekwyatt/vim-scala', { 'autoload' : {
            \ 'filetypes' : 'scala'
            \ }}


"" Git
NeoBundle "tpope/vim-fugitive"

"" Autocomplete
""" For vim 7.3.835 or above and if_lua enable
NeoBundle "Valloric/YouCompleteMe"

NeoBundle "SirVer/ultisnips"
NeoBundle 'honza/vim-snippets'



"" Syntax check
NeoBundle "scrooloose/syntastic"
NeoBundle "Twinside/vim-cuteErrorMarker"

"" Apperance 
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'bling/vim-airline'
NeoBundle 'mkitt/tabline.vim'
NeoBundleLazy 'octol/vim-cpp-enhanced-highlight', { 'autoload' : {
      \ 'filetypes' : 'cpp'
      \ }}
NeoBundleLazy "ap/vim-css-color", { 'autoload' : {
      \ 'filetypes' : 'css'
      \ }}
NeoBundleLazy "vim-scripts/DirDiff.vim", { 'autoload' : {
      \  'commands': 'DirDiff' 
      \ }}
NeoBundleLazy "aaronbieber/quicktask", { 'autoload' : {
      \ 'filetypes' : 'quicktask'
      \ }}
NeoBundleLazy "elentok/plaintasks.vim", { 'autoload' : {
      \ 'filetypes' : 'plaintasks'
      \ }}
"NeoBundleLazy 'yomi322/vim-gitcomplete', { 'autoload' : {
      "\ 'filetype' : 'vimshell'
      "\ }}
"NeoBundleLazy 'Shougo/vimshell', {
      "\ 'autoload' : {
      "\   'commands': 'VimShellInteractive' 
      "\ }}
NeoBundleLazy 'vim-scripts/Conque-GDB', { 'autoload' : {
      \ 'filetypes' : 'cpp'
      \ }}

call neobundle#end()

filetype plugin indent on

NeoBundleCheck
" }}}
" Unite: {{{
let g:unite_enable_split_vertically = 1

let g:unite_source_file_mru_long_limit = 3000
let g:unite_source_file_mru_time_format = "%m/%d %T "
let g:unite_source_directory_mru_limit = 80
let g:unite_source_directory_mru_long_limit = 3000
let g:unite_source_directory_mru_time_format = "%m/%d %T "
let g:unite_source_file_rec_max_depth = 20 

let g:unite_source_rec_max_cache_files = 2000

let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

let g:unite_enable_use_short_source_names = 1

"" File search
"call unite#filters#matcher_default#use(['matcher_fuzzy'])
"call unite#custom#source("file_rec", "ignore_pattern", "build/*")
noremap <silent><C-P> :Unite -no-split -start-insert file_rec buffer<CR>
noremap <silent><leader>p :UniteWithCursorWord -no-split -start-insert file_rec buffer<CR>
noremap <silent><leader>b :Unite -no-split -start-insert buffer file_mru bookmark<CR>


"" shortcup
"noremap <silent><leader>u  :<C-u>Unite -start-insert mapping<CR>

"" Execute help.
"noremap <silent><leader>h  :Unite -start-insert -no-split -default-action=tabopen help<CR>

"" Tab search/ switch
noremap <silent><leader>t :Unite -quick-match tab<CR>


"" Tag search

""" For searching the word in the cursor in tag file 
noremap <silent><leader>f :UniteWithCursorWord -no-split tag<CR>
noremap <silent><leader>ff :Unite tag -start-insert -no-split<CR>

"" grep dictionay

""" For searching the word in the cursor in the current directory
noremap <silent><leader>s :UniteWithCursorWord -no-split grep:.<CR>
noremap <silent><leader>ss :Unite -no-split grep:.<CR>

""" For searching the word in the cursor in the current buffer
noremap <silent><leader>sf :UniteWithCursorWord -no-split grep:%<CR>

""" For searching the word in the cursor in all opened buffer
noremap <silent><leader>sa :UniteWithCursorWord -no-split grep:$buffers<CR>

let g:unite_source_grep_default_opts = "-iRHn"
\ . " --exclude='tags'"
\ . " --exclude='cscope*'"
\ . " --exclude='*.svn*'"
\ . " --exclude='*.log*'"
\ . " --exclude='*tmp*'"
\ . " --exclude-dir='**/tmp'"
\ . " --exclude-dir='CVS'"
\ . " --exclude-dir='.svn'"
\ . " --exclude-dir='.git'"
\ . " --exclude-dir='node_modules'"

"" outline
nnoremap <leader>o :Unite -start-insert -no-split outline<CR>

"" Line search
nnoremap <leader>l :Unite line -start-insert -no-split<CR>

"" Yank history
let g:unite_source_history_yank_enable = 1
nnoremap <leader>y :<C-u>Unite -no-split -buffer-name=yank history/yank<cr>

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " Play nice with supertab
  let b:SuperTabDisabled=1
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction

nnoremap <silent> ;m :<C-u>Unite menu -resume<CR>

let g:unite_source_menu_menus = {}
let g:unite_source_menu_menus.interpreter = {
      \     'interpreter' : 'Run interpreter in VimShell.',
      \ }
let g:unite_source_menu_menus.interpreter.command_candidates = {
      \       'ghci'         : 'VimShellInteractive ghci',
      \       'python'       : 'VimShellInteractive python',
      \    }
let g:unite_source_menu_menus.unite = {
      \     'description' : 'Start unite sources.',
      \ }
let g:unite_source_menu_menus.unite.command_candidates = {
      \       'shortcut'        : 'Unite mapping',
      \       'help'            : 'Unite -start-insert -no-split -default-action=tabopen help',
      \       'history'         : 'Unite history/command',
      \       'quickfix'        : 'Unite qflist -no-quit',
      \       'resume'          : 'Unite -buffer-name=resume resume',
      \       'directory'       : 'Unite -buffer-name=files '.
      \             '-default-action=lcd directory_mru',
      \       'mapping'         : 'Unite mapping',
      \       'message'         : 'Unite output:message',
      \       'scriptnames'     : 'Unite output:scriptnames',
      \       'filetype'        : 'Unite -auto-preview filetype',
      \       'search plugin'   : 'Unite -no-split neobundle/search',
      \       'top'             : 'Unite process',
      \     }
let g:unite_source_menu_menus.enc = {
      \     'description' : 'Open with a specific character code again.',
      \ }
let g:unite_source_menu_menus.enc.command_candidates = [
      \       ['utf8', 'Utf8'],
      \       ['iso2022jp', 'Iso2022jp'],
      \       ['cp932', 'Cp932'],
      \       ['euc', 'Euc'],
      \       ['utf16', 'Utf16'],
      \       ['utf16-be', 'Utf16be'],
      \       ['jis', 'Jis'],
      \       ['sjis', 'Sjis'],
      \       ['unicode', 'Unicode'],
      \     ]
" }}}
" Airline: {{{
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_iminsert=0
let g:airline#extensions#whitespace#enabled = 0 
" }}}
" VimFiler: {{{
"call vimfiler#set_execute_file('txt', 'vim')
"call vimfiler#set_execute_file('c', 'vim')
"call vimfiler#set_execute_file('cpp', 'vim')
"call vimfiler#set_execute_file('python', 'vim')

let g:vimfiler_as_default_explorer = 1
" }}}
"Tagbar: {{{

let g:tagbar_ctags_bin = 'ctags'
let g:tagbar_width = 30
let g:tagbar_autofocus = 1

" }}}
" NERDTree: {{{
let NERDTreeWinSize = 20
" }}}
" Markdown: {{{
let g:vim_markdown_folding_disabled=1
" }}}
" Cctree: {{{
" set updatetime
set updatetime=0
let g:CTreeRecursiveDepth = 10 
let g:CCTreeKeyTraceForwardTree = ''
let g:CCTreeKeyTraceReverseTree = ''
let g:CCTreeKeyToggleWindow = '<leader>w'

nnoremap <leader>. :CCTreeTraceForward <C-R><C-w><CR>
nnoremap <leader>, :CCTreeTraceReverse <C-R><C-w><CR>

" }}}
" Doxygentoolkit: {{{

nmap <leader>d :Dox<CR> 

" }}}
" Pymode: {{{
let g:pymode_rope = 0
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_completion = 0
" }}}
" HaskellMode: {{{

let g:haddock_browser = "open"
let g:haddock_browser_callformat = "%s %s"

" }}}
" Syntastic: {{{

nnoremap <leader>e :Errors<CR>
nnoremap <Leader>ee :SyntasticToggleMode<CR>

let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++ -I./inc'

" }}}
" EasyMotion: {{{
"
let g:EasyMotion_leader_key = '\'

" }}}
" YouCompleteMe: {{{
let g:ycm_autoclose_preview_window_after_insertion = 1

" }}}
" Ultisnips: {{{

" Snippets are separated from the engine. Add this if you want them:

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-y>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" }}}
endif " if v:version >= 702

" vim: ft=vim foldmethod=marker foldcolumn=1
