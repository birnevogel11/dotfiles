" General: {{{
set nocompatible
filetype off

" remapping the leader key
let mapleader = ","

" }}}
" Plugin: {{{
"" Let NeoBundle manage NeoBundle

call plug#begin('~/.vim/plugged')

"" Recommended to install
"" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
Plug 'Shougo/vimproc.vim', { 'do': 'make' }

"" unite.vim and plugins
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'tsukkee/unite-tag'
Plug 'Shougo/unite-outline'
Plug 'Shougo/unite-help'
Plug 'ujihisa/unite-launch'
Plug 'ujihisa/unite-locate'
Plug 'osyo-manga/unite-filetype'
Plug 'thinca/vim-unite-history'
Plug 'Shougo/neobundle-vim-recipes'
Plug 'thinca/vim-qfreplace'

Plug 'Shougo/vimfiler.vim'

"" Edit
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-speeddating'
Plug 'scrooloose/nerdcommenter'
Plug 'Raimondi/delimitMate'

Plug 'plasticboy/vim-markdown', {'for': ['mkd', 'markdown']}
Plug 'Rykka/riv.vim', {'for': 'rst'}
Plug 'mattn/emmet-vim', {'for': 'html'}
Plug 'michaeljsmith/vim-indent-object'
Plug 'vim-scripts/DoxygenToolkit.vim', {'for': ['c', 'cpp', 'doxygen']} 
Plug 'Lokaltog/vim-easymotion'

"" IDE 
Plug 'MarcWeber/vim-addon-mw-utils'

""" C/ C++
Plug 'simplyzhao/cscope_maps.vim', {'for': ['c', 'cpp']} 
Plug 'rhysd/vim-clang-format', {'for': ['c', 'cpp']} 
Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['c', 'cpp']} 
"Plug 'osyo-manga/vim-marching', {'for': ['c', 'cpp']} 
"Plug 'ustmao945/vim-clang', {'for': ['c', 'cpp']} 

""" Haskell
Plug 'vim-scripts/haskell.vim', {'for': 'haskell'} 
Plug 'ujihisa/neco-ghc', {'for': 'haskell'} 
Plug 'ujihisa/repl.vim', {'for': 'haskell'} 
"Plug 'Twinside/vim-haskellConceal', {'for': 'haskell'} 
"Plug 'lukerandall/haskellmode-vim', {'for': 'haskell'} 
"Plug 'frerich/unicode-haskell', {'for': 'haskell'} 
"
""" Python 
Plug 'klen/python-mode', {'for': 'python'} 
Plug 'xitianfz/vim-python-syntax', {'for': 'python'} 

"" Git
Plug 'tpope/vim-fugitive'


"" Autocomplete
""" For vim 7.3.835 or above and if_lua enable
"Plug 'Shougo/neocomplete.vim'

if v:version >= 704
    if has("mac")
Plug 'Shougo/neocomplete'
    else
Plug 'Shougo/neocomplcache.vim'
    endif
endif

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

"" Syntax check
Plug 'scrooloose/syntastic'
Plug 'Twinside/vim-cuteErrorMarker'

"" Apperance 
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'mkitt/tabline.vim'

Plug 'ap/vim-css-color', {'for': 'css'}
Plug 'vim-scripts/DirDiff.vim', {'on': 'DirDiff'}

"Plug 'vim-scripts/Conque-GDB' 

"" Autocomplete
" Track the engine.
Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

Plug 'Valloric/YouCompleteMe', { 'do': './install.sh  --clang-completer' }

call plug#end()

filetype plugin indent on

"NeoBundleCheck
" }}}
" Unite: {{{
let g:unite_enable_split_vertically = 1

let g:unite_source_file_mru_long_limit = 5000
let g:unite_source_file_mru_time_format = "%m/%d %T "
let g:unite_source_directory_mru_limit = 80
let g:unite_source_directory_mru_long_limit = 5000
let g:unite_source_directory_mru_time_format = "%m/%d %T "
let g:unite_source_file_rec_max_depth = 20 

let g:unite_source_rec_max_cache_files = 5000

let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

let g:unite_enable_use_short_source_names = 1

"" File search
"call unite#filters#matcher_default#use(['matcher_fuzzy'])
"call unite#custom#source("file_rec", "ignore_pattern", "build/*")
noremap <silent><C-P> :Unite -start-insert file_rec buffer<CR>
noremap <silent><leader>p :UniteWithCursorWord -start-insert file_rec buffer<CR>
noremap <silent><leader>b :Unite -start-insert buffer file_mru bookmark<CR>


"" shortcup
"noremap <silent><leader>u  :<C-u>Unite -start-insert mapping<CR>

"" Execute help.
"noremap <silent><leader>h  :Unite -start-insert -default-action=tabopen help<CR>

"" Tab search/ switch
noremap <silent><leader>t :Unite -quick-match tab<CR>


"" Tag search

""" For searching the word in the cursor in tag file 
noremap <silent><leader>f :UniteWithCursorWord tag<CR>
noremap <silent><leader>ff :Unite tag -start-insert -no-split<CR>

"" grep dictionay

""" For searching the word in the cursor in the current directory
noremap <silent><leader>s :UniteWithCursorWord grep:.<CR>
noremap <silent><leader>ss :Unite grep:.<CR>

""" For searching the word in the cursor in the current buffer
noremap <silent><leader>sf :UniteWithCursorWord grep:%<CR>

""" For searching the word in the cursor in all opened buffer
noremap <silent><leader>sa :UniteWithCursorWord grep:$buffers<CR>

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
nnoremap <leader>o :Unite -start-insert outline<CR>

"" Line search
nnoremap <leader>l :Unite line -start-insert -no-split<CR>

"" Yank history
let g:unite_source_history_yank_enable = 1
nnoremap <leader>y :<C-u>Unite -buffer-name=yank history/yank<cr>

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

if has("gui_macvim")
	" Like Textmate icons.
	let g:vimfiler_tree_leaf_icon = ' '
	let g:vimfiler_tree_opened_icon = '▾'
	let g:vimfiler_tree_closed_icon = '▸'
	let g:vimfiler_file_icon = '-'
	let g:vimfiler_marked_file_icon = '*'
endif

" }}}
" Markdown: {{{
let g:vim_markdown_folding_disabled=1
" }}}
" Doxygentoolkit: {{{

nmap <leader>d :Dox<CR> 

" }}}
" Pymode: {{{
"
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
"let g:pymode_rope = 1
let g:pymode_rope = 0
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_completion = 0

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
" Auto check on save
let g:pymode_lint_write = 1

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

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
map <Leader>w <Plug>(easymotion-prefix)

" }}}
" ClangFormant: {{{
let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "TabWidth" : 4,
            \ "MaxEmptyLinesToKeep": 2,
            \ "Standard" : "C++11"}


" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)

" }}}
" Vim-cpp-enhanced-highlight: {{{
let g:cpp_class_scope_highlight = 1
let g:cpp_experimental_template_highlight = 1
" }}}
" UltiSnips :{{{
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>

" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
