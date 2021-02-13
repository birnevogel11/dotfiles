" zM: fold all
" zR: unfold all

" Esc Keymapping: {{{
inoremap jk <esc>
" "}}}
" ColorScheme: {{{

" enable true color
if has("termguicolors")
  set termguicolors
endif

syntax enable
colorscheme onedarkishii

" }}}
" General: {{{
syntax enable

set ttyfast
set number

set autoread            " auto reload file when the file content is changed

set ruler               " show the cursor position all the time
set autoread            " auto read when file is changed from outside

filetype on             " Enable filetype detection
filetype plugin on      " Enable filetype-specific plugins
filetype indent on      " Enable filetype-specific indenting

"" status line
set laststatus=2

set showmode            " Show current input mode in status line
set cursorline          " Show Cursor Line in Underline
"set showtabline=2
set wildmenu            " Show autocomplete menus.

"" set column width
set colorcolumn=80

set nobackup
set noswapfile

" Set to auto read when a file is changed from the outside
set autoread

" Disable readonly warning
augroup no_ro_warn
    au!
    au FileChangedRO * set noreadonly
augroup END

" Diff algorithm
set diffopt=internal,filler,indent-heuristic,algorithm:histogram
" "}}}
" Set title: {{{
if &term == "screen"
  set t_ts=^[k
  set t_fs=^[\
endif
set title
set titlestring=%F\ -\ %{hostname()}
" }}}
" Set_encoding: {{{
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
" set ambiwidth=double
" "}}}
" Disable_sound_on_errors: {{{
" Disable bleep!
set visualbell
set noerrorbells

set novisualbell
set tm=500
" "}}}
" Search: {{{
set showcmd
set incsearch
set showmatch
set ignorecase
set smartcase

set hls

nnoremap <ESC>u :nohl<CR>
" "}}}
" Indent: {{{
set backspace=indent,eol,start
set autoindent
set smarttab            " insert tabs on the start of a line according to context
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" indent key mapping
nnoremap <tab> v>
nnoremap <s-tab> v<
vnoremap <tab> >gv
vnoremap <s-tab> <gv
" "}}}
" Tab Setting: {{{
"set list
set listchars=tab:>-

nnoremap <leader>tc :tabnew<CR>
nnoremap <leader>te :tabedit<SPACE>
nnoremap <leader>tm :tabmove<SPACE>

" nnoremap <C-M> :tabprev<CR>
nnoremap <C-N> :tabnext<CR>
nnoremap tj :tabnext<CR>
nnoremap tk :tabnext<CR>

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>
" }}}
" Filetype: {{{
"" JavaScript
au BufNewFile,BufRead *.js set filetype=javascript.jsx
au BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css

"" Yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
"}}}
" Programming: {{{
"" Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm'\"")|else|exe "norm $"|endif|endif

function s:yen3_remove_unncessary_space()
  "" Remove trailing space
  call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

  " Remove blank lines in the end of file
  :%s#\($\n\s*\)\+\%$##
endfunction

augroup remove_unnecessary_space
  au!
  autocmd FileType c,cpp,java,groovy,php,cabal,cpp,haskell,javascript,python,text,yaml,vim,markdown,zsh,sh,lex,yacc,rust,lua
    \ autocmd BufWritePre <buffer>
    \ :silent! call s:yen3_remove_unncessary_space()
augroup END

set completeopt-=preview

" Reread (i.e reload) all buffers (useful when git pulling)
nnoremap <silent> <leader>rr :checktime<CR>
"}}}
" Auto Swith-Paste: {{{
" ref: http://blog.longwin.com.tw/2014/12/vim-linux-mac-putty-paste-mode-change-2014/
if &term =~ "xterm.*"
    let &t_ti = &t_ti . "\e[?2004h"
    let &t_te = "\e[?2004l" . &t_te
    function XTermPasteBegin(ret)
        set pastetoggle=<Esc>[201~
        set paste
        return a:ret
    endfunction
    map <expr> <Esc>[200~ XTermPasteBegin("i")
    imap <expr> <Esc>[200~ XTermPasteBegin("")
    cmap <Esc>[200~ <nop>
    cmap <Esc>[201~ <nop>
endif
" }}}
" Split and window {{{
" set splitbelow

" Resize splits when the Vim window is resized
augroup vim_resized
  au!
  au VimResized * :wincmd =
augroup END

" Only show cursorline in the current window
augroup cline
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * if &filetype !=# 'denite' | setlocal nocursorline | endif
augroup END
" }}}
" Quickfix {{{
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction

nnoremap <silent> <leader>qf :QFix<cr>
nnoremap <silent> ]q :<C-U>execute v:count1 . 'cnext'<CR>
nnoremap <silent> [q :<C-U>execute v:count1 . 'cprevious'<CR>
" }}}
" config mapping {{{
nnoremap <silent> <leader>rv :source $MYVIMRC<cr>
nnoremap <silent> <leader>re :e $DOTVIM/vimrc<cr>
" }}}
" xml setting: {{{
if executable('xmllint')
  au FileType xml exe ":silent %!xmllint --format --recover - 2>/dev/null"
endif
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
