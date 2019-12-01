" zM: fold all
" zR: unfold all

" Esc Keymapping: {{{
inoremap jk <esc>
" "}}}
" ColorScheme: {{{

" Disable true color support temporary
" if has("termguicolors")
"     " fix bug for vim
"     set t_8f=^[[38;2;%lu;%lu;%lum
"     set t_8b=^[[48;2;%lu;%lu;%lum
"
"     " enable true color
"     set termguicolors
" endif

syntax enable
if has('nvim') && filereadable($HOME.'/.cache/dein/.cache/init.vim/.dein/colors/Tomorrow-Night-Bright.vim')
  colorscheme Tomorrow-Night-Bright
endif

" }}}
" General: {{{
"" auto reload vimrc when editing it
autocmd! bufwritepost .vimrc source ~/.vimrc

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

set title
set showmode            " Show current input mode in status line
set cursorline          " Show Cursor Line in Underline
"set showtabline=2
set wildmenu            " Show autocomplete menus.

"" set column width
set colorcolumn=79

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
" Set_encoding: {{{
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set ambiwidth=double
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
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

augroup ansible_vim_fthosts
  autocmd!
  autocmd BufNewFile,BufRead hosts setfiletype yaml.ansible
augroup END
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
  autocmd FileType c,java,php,cabal,cpp,haskell,javascript,php,python,readme,text,yaml,vim,markdown,zsh,sh
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
nnoremap <silent> <leader>qf :copen<cr>
nnoremap <silent> <leader>qc :cclose<cr>
nnoremap <silent> ]q :<C-U>execute v:count1 . 'cnext'<CR>
nnoremap <silent> [q :<C-U>execute v:count1 . 'cprevious'<CR>
" }}}
" config mapping {{{
nnoremap <silent> <Leader>rv :so $DOTVIM/init.vim<CR>
nnoremap <silent> <Leader>re :e  $DOTVIM/vimrc<CR>
" }}}
" Terminal {{{
" ref: https://github.com/petobens/dotfiles/blob/master/vim/init.vim#L973-L992
if exists(':tnoremap')
    " Exit terminal mode and return to vim normal mode (essentially the terminal
    " now becomes a regular vim buffer)
    " Note: we don't want to do this with <ESC> because when using vi mode most
    " readline programs actually use ESC to enter normal mode; since we
    " might also use jj to get into normal mode from within the readline program
    " we also avoid remapping it here and prefer kj instead
    " tnoremap <Esc> <C-\><C-n>
    tnoremap jk <C-\><C-n>
    " Window movement
    tnoremap <c-k> <C-\><C-n><C-w>k
    tnoremap <c-h> <C-\><C-n><C-w>h
    tnoremap <c-l> <C-\><C-n><C-w>l
    tnoremap <c-j> <C-\><C-n><C-w>j
endif

if has('nvim')
  " ref: https://github.com/neovim/neovim/issues/8816
  let g:previous_window = -1

  function SmartInsert()
    if &buftype == 'terminal'
      if g:previous_window != winnr()
        startinsert
      endif
      let g:previous_window = winnr()
    else
      let g:previous_window = -1
    endif
  endfunction

  au BufEnter * call SmartInsert()

  nnoremap <silent> <leader>rt :belowright 10split term://zsh<cr>
  nnoremap <silent> <leader>rT :belowright 60vsplit term://zsh<cr>
endif
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
