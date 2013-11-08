" Yen3's vimrc
" In normal mode type `zo`/ `zc` can open/ clode a fold block

" Plugin: {{{

set nocompatible
filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

 call neobundle#rc(expand('~/.vim/bundle/'))

"" Let NeoBundle manage NeoBundle
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

"" Edit
NeoBundle "tpope/vim-surround"
NeoBundle "tpope/vim-endwise"
NeoBundle "tpope/vim-speeddating"
NeoBundle "scrooloose/nerdcommenter"
NeoBundleLazy 'plasticboy/vim-markdown', { 'autoload' : {
      \ 'filetypes' : 'mkd'
      \ }}
NeoBundleLazy 'mattn/emmet-vim', { 'autoload' : {
      \ 'filetypes' : 'html'
      \ }}
NeoBundle "michaeljsmith/vim-indent-object"
NeoBundle "vim-scripts/DoxygenToolkit.vim"

"" IDE 
"NeoBundle 'scrooloose/nerdtree'
NeoBundle "MarcWeber/vim-addon-mw-utils"
NeoBundle "Shougo/vimfiler.vim"
"NeoBundle 'majutsushi/tagbar'

"" Trace code
NeoBundle "simplyzhao/cscope_maps.vim"
NeoBundleLazy 'vim-scripts/CCTree' , { 'autoload' : {
      \ 'filetypes' : 'c'
      \ }}


"" unite.vim and plugins
NeoBundle 'Shougo/unite.vim'
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


"" Haskell
"NeoBundle "lukerandall/haskellmode-vim"
"NeoBundle "vim-scripts/Superior-Haskell-Interaction-Mode-SHIM"
"NeoBundle "Twinside/vim-haskellConceal"
NeoBundleLazy 'ujihisa/neco-ghc', { 'autoload' : {
      \ 'filetypes' : 'haskell'
      \ }}

"" Python
NeoBundleLazy 'klen/python-mode', { 'autoload' : {
      \ 'filetypes' : 'python'
      \ }}

"" Git
NeoBundle "tpope/vim-fugitive"

"" Autocomplete
""" For vim 7.3.835 or above and if_lua enable
"NeoBundle "Shougo/neocomplete.vim"
NeoBundle "Shougo/neocomplcache.vim"
NeoBundle "Shougo/neosnippet.vim"

"" Syntax check
NeoBundle 'scrooloose/syntastic'
NeoBundle 'Twinside/vim-cuteErrorMarker'

"" Apperance 
NeoBundle 'bling/vim-airline'
NeoBundle 'mkitt/tabline.vim'
NeoBundleLazy "ap/vim-css-color", { 'autoload' : {
      \ 'filetypes' : 'css'
      \ }}
NeoBundleLazy 'octol/vim-cpp-enhanced-highlight', { 'autoload' : {
      \ 'filetypes' : 'cpp'
      \ }}

"" Misc
NeoBundleLazy "elentok/plaintasks.vim", { 'autoload' : {
      \ 'filetypes' : 'plaintasks'
      \ }}
"NeoBundleLazy 'basyura/TweetVim', { 'depends' :
      "\ ['basyura/twibill.vim', 'tyru/open-browser.vim'],
      "\ 'autoload' : { 'commands' : 'TweetVimHomeTimeline' }}
      "" \ ['basyura/twibill.vim', 'tyru/open-browser.vim', 'yomi322/neco-tweetvim'] }
NeoBundle 'Shougo/vimshell'
NeoBundleLazy 'yomi322/vim-gitcomplete', { 'autoload' : {
      \ 'filetype' : 'vimshell'
      \ }}

filetype plugin indent on

NeoBundleCheck
" }}}
" General: {{{

"" auto reload vimrc when editing it
autocmd! bufwritepost .vimrc source ~/.vimrc

syntax enable
set t_Co=256          " 256 color mode
set background=dark

if has("gui_running")   " GUI color and font settings
    set guifont=Source\ Code\ Pro:h20
    set cursorline        " highlight current line
    highlight SpellBad term=underline gui=undercurl guisp=Orange
endif

color Tomorrow-Night-Bright

set ttyfast
set number

set nocompatible        " not compatible with the old-fashion vi mode
set ruler               " show the cursor position all the time
set autoread            " auto read when file is changed from outside

filetype on           " Enable filetype detection
filetype plugin on    " Enable filetype-specific plugins
filetype indent on    " Enable filetype-specific indenting

"" status line
set laststatus=2

set title
set showmode            " Show current input mode in status line
set cursorline         " Show Cursor Line in Underline
"set showtabline=2
set wildmenu " Show autocomplete menus.
set visualbell

" }}}
" Set_encoding: {{{
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,big5,euc-jp,gbk,euc-kr,utf-bom,iso8859-1
set termencoding=utf-8
set ambiwidth=double
" }}}
" Disable_sound_on_errors: {{{
set noerrorbells
set novisualbell
set tm=500

" }}}
" Search_setting: {{{
set showcmd
set incsearch
set showmatch

set hls

" }}}
" Folding: {{{
""" set folding
"set foldnestmax=3
"set foldmethod=syntax
"set foldcolumn=4

" }}}
" Indent_setting: {{{

set autoindent
set expandtab
set shiftwidth=4
set softtabstop=8
set tabstop=4
set smarttab            " insert tabs on the start of a line according to context
set backspace=indent,eol,start

" }}}
" Function_key: {{{

nmap <silent><F2> :VimFiler<CR>
"nmap <silent><F3> :TagbarToggle<CR>
"nmap <silent><F4> :SrcExplToggle<CR>
nmap <silent><F6> :CCTreeLoadDB cscope.out<CR>

autocmd FileType c,cpp nmap <silent><F5> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q . && cscope -bR<CR>
autocmd FileType python nmap <silent><F5> :!ctags -R .<CR>
autocmd FileType haskell nmap <silent><F5> :!hasktags -c .<CR>
" }}}
" Nohl: {{{

nmap <ESC>u :nohl<CR>

" }}}
" Edit_tab_setting: {{{

nmap <leader>tc :tabnew<CR>
nmap <leader>te :tabedit<SPACE>
nmap <leader>tm :tabmove<SPACE>
nmap <leader>tk :tabclose<CR>
nmap <C-H> :tabprev<CR>
nmap <C-L> :tabnext<CR>

autocmd TabLeave * let g:LastUsedTabPage = tabpagenr()
function! SwitchLastUsedTab()
    if exists("g:LastUsedTabPage")
        execute "tabnext " g:LastUsedTabPage
    endif
endfunction

nmap tt :call SwitchLastUsedTab()<CR>

" }}}
" OSX_Copy_Paste: {{{

"" Copy & Paste Shortcut(s)
vmap <leader>y y:call system("pbcopy", getreg("\""))<CR>
vmap <leader>x x:call system("pbcopy", getreg("\""))<CR>
nmap <leader>p :call setreg("\"",system("pbpaste"))<CR>

" }}}
" Indent_key: {{{

nmap <tab> v>
nmap <s-tab> v<
vmap <tab> >gv
vmap <s-tab> <gv

" }}}
" Programming: {{{

nmap <leader>m :make<cr>
"nmap <leader>, :make clean<cr>
nmap <leader>q :SQFix<cr>

com! -bang -nargs=? SQFix cal QFixToggle(<bang>0)
fu! QFixToggle(forced)
    if exists("g:qfix_win") && a:forced == 0
        cclose
        unlet g:qfix_win
    else
        copen 10
        let g:qfix_win = bufnr("$")
        en
    endf

"" open the error console
nmap <leader>cc :botright cope<CR>
map <C-n> <ESC>:cnext<CR>
map <C-p> <ESC>:cprev<CR>

map <S-F8> <ESC>:colder<CR>
map <C-F8> <ESC>:cnewer<CR>

"" Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm'\"")|else|exe "norm $"|endif|endif

"" Auto remove each line-end space
autocmd FileType c,cpp,java,php,perl,python,ruby,sh,v,tex autocmd BufWritePre  :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","
")'))


" }}}
" Filetype: {{{

"" MD32 Assembly
au BufNewFile,BufRead *.s set filetype=md32asm


"" C/ CPP with doxygen
au BufNewFile,BufRead *.c set filetype=c.cpp.doxygen
au BufNewFile,BufRead *.cpp set filetype=cpp.doxygen
au BufNewFile,BufRead *.h set filetype=c.cpp.doxygen

"" Markdown
au BufNewFile,BufRead *.md set filetype=mkd.markdown
au BufNewFile,BufRead *.mkd set filetype=mkd.markdown
au BufNewFile,BufRead *.markdown set filetype=mkd.markdown

" }}}
" Tab_bar_color: {{{

hi TabLine           cterm=underline ctermfg=15    ctermbg=242   gui=underline guibg=#6c6c6c guifg=White
hi TabLineSel        cterm=bold      gui=NONE      guifg=White
hi TabLineFill       cterm=reverse   gui=reverse

"hi TabLineFill      cterm=NONE      ctermfg=63      ctermbg=235
"hi TabLine          cterm=NONE      ctermfg=253     ctermbg=242
"hi TabLineSel       cterm=UNDERLINE ctermfg=253     ctermbg=61

"" }}}
" Unite: {{{

let g:unite_enable_split_vertically = 1

let g:unite_source_file_mru_time_format = "%m/%d %T "
let g:unite_source_directory_mru_limit = 80
let g:unite_source_directory_mru_time_format = "%m/%d %T "
let g:unite_source_file_rec_max_depth = 5

let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

"" File search

nnoremap <silent><C-p> :Unite -no-split -start-insert file_rec buffer<CR>

"" shortcup
nnoremap <silent><C-u>  :<C-u>Unite -start-insert mapping<CR>

"" Execute help.
nnoremap <silent><leader>h  :Unite -start-insert -no-split help<CR>

"" Tag search

""" For searching the word in the cursor in tag file 
nnoremap <silent><leader>f :Unite -no-split tag:<C-R><C-w><CR>

nnoremap <silent><leader>ff :Unite tag -start-insert -no-split<CR>

"" grep dictionay

""" For searching the word in the cursor in the current directory
nnoremap <silent><leader>s :Unite -no-split grep:.::<C-R><C-w><CR>

""" For searching the word handin
nnoremap <silent><leader>ss :Unite -no-split grep:.<CR>

""" For searching the word in the cursor in the current buffer
noremap <silent><leader>sf :Unite -no-split grep:%::<C-r><C-w><CR>

""" For searching the word in the cursor in all opened buffer
noremap <silent><leader>sa :Unite -no-split grep:$buffers::<C-r><C-w><CR>

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

" search plugin
" :Unite neobundle/search

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
" Airline: {{{

let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_iminsert=1

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
" Neocomplcache: {{{

"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
"let g:neocomplcache_enable_underbar_completion = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType java set omnifunc=javacomplete#Complete


if has("autocmd") && exists("+omnifunc")
    autocmd Filetype *
        \   if &omnifunc == "" |
        \           setlocal omnifunc=syntaxcomplete#Complete |
        \   endif
endif

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" }}}
" Neosnippet: {{{

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" }}}
" Doxygentoolkit: {{{

nmap <leader>d :Dox<CR> 

" }}}
" VimFiler: {{{

let g:vimfiler_as_default_explorer = 1

" }}}

" vim: foldmethod=marker foldcolumn=1

