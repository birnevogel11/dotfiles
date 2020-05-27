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
" Reload my vimrc
nnoremap <leader>rv :so %<cr>

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
  tnoremap <silent> <c-k> <C-\><C-n><C-w>k
  tnoremap <silent> <c-h> <C-\><C-n><C-w>h
  tnoremap <silent> <c-l> <C-\><C-n><C-w>l
  tnoremap <silent> <c-j> <C-\><C-n><C-w>j
  " Close window
  tnoremap <silent> <c-q> <C-\><C-n>:q<CR>
endif

if has('nvim')
  " ref: https://gist.github.com/ram535/b1b7af6cd7769ec0481eb2eed549ea23
  " With this function you can reuse the same terminal in neovim.
  " You can toggle the terminal and also send a command to the same terminal.

  let s:monkey_terminal_window = -1
  let s:monkey_terminal_buffer = -1
  let s:monkey_terminal_job_id = -1

  function! MonkeyTerminalOpen()
    " Check if buffer exists, if not create a window and a buffer
    if !bufexists(s:monkey_terminal_buffer)
      " Creates a window call monkey_terminal
      " new monkey_terminal
      new monkey_terminal
      " Moves to the window the right the current one
      wincmd J
      resize 10
      let s:monkey_terminal_job_id = termopen($SHELL, { 'detach': 1 })

       " Change the name of the buffer to "Terminal 1"
       silent file Terminal\ 1
       " Gets the id of the terminal window
       let s:monkey_terminal_window = win_getid()
       let s:monkey_terminal_buffer = bufnr('%')

      " The buffer of the terminal won't appear in the list of the buffers
      " when calling :buffers command
      set nobuflisted

      startinsert
    else
      if !win_gotoid(s:monkey_terminal_window)
      sp
      " Moves to the window below the current one
      wincmd J
      resize 10
      buffer Terminal\ 1
       " Gets the id of the terminal window
       let s:monkey_terminal_window = win_getid()
      endif
    endif
  endfunction

  function! MonkeyTerminalToggle()
    if win_gotoid(s:monkey_terminal_window)
      call MonkeyTerminalClose()
    else
      call MonkeyTerminalOpen()
    endif
  endfunction

  function! MonkeyTerminalClose()
    if win_gotoid(s:monkey_terminal_window)
      " close the current window
      hide
    endif
  endfunction

  function! MonkeyTerminalExec(cmd)
    if !win_gotoid(s:monkey_terminal_window)
      call MonkeyTerminalOpen()
    endif

    " clear current input
    call jobsend(s:monkey_terminal_job_id, "clear\n")

    " run cmd
    call jobsend(s:monkey_terminal_job_id, a:cmd . "\n")
    normal! G
    wincmd p
  endfunction


  " This an example on how specify command with different types of files.
      " augroup go
          " autocmd!
          " autocmd BufRead,BufNewFile *.go set filetype=go
          " autocmd FileType go nnoremap <F5> :call MonkeyTerminalExec('go run ' . expand('%'))<cr>
        " augroup END

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

  function! OnTermClose()
    " Try to move the cursor to the last line containing text
    try
        $;?.
    catch
        " The buffer is empty here. This shouldn't ever happen
        return
    endtry
    " Is the last line an error message?
    if match(getline('.'), 'make: \*\*\* \[[^\]]\+] Error ') == -1
        call feedkeys('a ')
    endif
  endfunction

  augroup MY_TERM_AUGROUP
    autocmd!
    au TermClose * silent call OnTermClose()
    au BufEnter * call SmartInsert()
  augroup END

  nnoremap <silent> <leader>rT :belowright vsplit term://zsh<cr>
  " With this maps you can now toggle the terminal
  nnoremap <silent> <leader>rt :call MonkeyTerminalToggle()<cr>
  tnoremap <silent> <C-Q> <C-\><C-n>:call MonkeyTerminalToggle()<cr>
endif
" }}}
" Git commit format setting {{{
autocmd Filetype gitcommit setlocal spell textwidth=72 colorcolumn=72
" }}}
" xml setting: {{{
if executable('xmllint')
  au FileType xml exe ":silent %!xmllint --format --recover - 2>/dev/null"
endif
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
