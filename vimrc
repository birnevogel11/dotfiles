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

NeoBundle 'Shougo/unite.vim'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'tsukkee/unite-help'
NeoBundle 'ujihisa/unite-launch'

NeoBundle 'bling/vim-airline'
NeoBundle 'scrooloose/nerdtree'
NeoBundle "MarcWeber/vim-addon-mw-utils"

NeoBundle 'majutsushi/tagbar'
NeoBundle 'simplyzhao/cscope_maps.vim'
NeoBundle 'wesleyche/SrcExpl.git'
NeoBundle 'vim-scripts/CCTree'

NeoBundle 'scrooloose/syntastic'
NeoBundle 'Twinside/vim-cuteErrorMarker'

NeoBundle "tomtom/tlib_vim"
NeoBundle "garbas/vim-snipmate"
NeoBundle "L9"
NeoBundle "othree/vim-autocomplpop"
NeoBundle "vim-scripts/OmniCppComplete"
"NeoBundle "ervandew/supertab"

NeoBundle "scrooloose/nerdcommenter"
NeoBundle "plasticboy/vim-markdown"
"NeoBundle "vim-scripts/DoxygenToolkit.vim"

NeoBundle "octol/vim-cpp-enhanced-highlight"

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


""" set folding
"set foldnestmax=3
"set foldmethod=syntax
"set foldcolumn=4

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

nmap <silent><F2> :NERDTree<CR>
nmap <silent><F3> :TagbarToggle<CR>
nmap <silent><F4> :SrcExplToggle<CR>
nmap <silent><F5> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q . && cscope -bR<CR>
nmap <silent><F6> :CCTreeLoadDB cscope.out<CR>
nmap <silent><F7> :set foldmethod=syntax<CR>

" }}}


" Tab_setting: {{{

nmap tc :tabnew<CR>
nmap te :tabedit<SPACE>
nmap tm :tabmove<SPACE>
nmap tk :tabclose<CR>
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
nmap <leader>, :make clean<cr>
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
autocmd FileType c,cpp,java,php,perl,python,ruby,sh,v,tex autocmd BufWritePre  :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))


" }}}

" Filetype: {{{

"" C/ CPP with doxygen
au BufNewFile,BufRead *.c set filetype=cpp.doxygen
au BufNewFile,BufRead *.cpp set filetype=cpp.doxygen
au BufNewFile,BufRead *.h set filetype=cpp.doxygen

"" Markdown
au BufNewFile,BufRead *.md set filetype=makrdown
au BufNewFile,BufRead *.mkd set filetype=markdown
au BufNewFile,BufRead *.markdown set filetype=markdown

" }}}

" Auto_complete: {{{

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

" }}}


" Tabcolor: {{{

hi TabLineFill      cterm=NONE      ctermfg=63      ctermbg=235
hi TabLine          cterm=NONE      ctermfg=253     ctermbg=242
hi TabLineSel       cterm=BOLD      ctermfg=253     ctermbg=61

" }}}

" Unite: {{{

let g:unite_enable_split_vertically = 1

let g:unite_source_file_mru_time_format = "%m/%d %T "
let g:unite_source_directory_mru_limit = 80
let g:unite_source_directory_mru_time_format = "%m/%d %T "
let g:unite_source_file_rec_max_depth = 5

let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

nmap <C-p> :Unite -start-insert file_rec buffer<CR>

"" shortcup
nnoremap <C-u>  :<C-u>Unite -start-insert mapping<CR>

" Execute help.
nnoremap <leader>h  :Unite -start-insert help<CR>

"" grep dictionay

""" For searching the word in the cursor in the current directory
nnoremap <Leader>s :Unite grep:.::<C-R><C-w><CR>

""" For searching the word in the cursor in the current buffer
noremap <silent> <Leader>sf :Unite grep:%::<C-r><C-w><CR>

""" For searching the word in the cursor in all opened buffer
noremap <silent> <Leader>sa :Unite grep:$buffers::<C-r><C-w><CR>
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

""" For searching the word handin
nnoremap <Leader>ss :Unite grep:.<CR>

" outline
nnoremap <leader>o ::Unite outline<CR>

" yank history
let g:unite_source_history_yank_enable = 1
let g:unite_source_history_yank_limit = 40
nnoremap <leader>y :Unite history/yank<CR>

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

let g:airline_theme='luna'

let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_iminsert=1
" let g:airline_inactive_collapse=1

" }}}

" Autocomplpop: {{{

"" acp options
let g:acp_enableAtStartup = 1
let g:acp_completeOption = '.,w,b,u,t,i,k'
let g:acp_behaviorSnipmateLength = 1

let g:acp_behaviorUserDefinedMeets = 'acp#meetsForKeyword'
let g:acp_behaviorUserDefinedFunction = 'syntaxcomplete#Complete'

" }}}



" Cctree: {{{

" set updatetime
set updatetime=0
let g:CTreeRecursiveDepth = 6
let g:CCTreeKeyTraceForwardTree = '<leader>.'
let g:CCTreeKeyTraceReverseTree = '<leader>,'
let g:CCTreeKeyToggleWindow = '<leader>w'

" }}}

