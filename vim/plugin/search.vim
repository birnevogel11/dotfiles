" Fzf: {{{
if has("gui_running") && has("mac")
let g:fzf_launcher = "/Users/yen3/.personal_scripts/fzf_macvim_start.sh %s"
endif

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Customize fzf colors to match your color scheme
"let g:fzf_colors =
"\ { 'fg':      ['fg', 'Normal'],
  "\ 'bg':      ['bg', 'Normal'],
  "\ 'hl':      ['fg', 'Function'],
  "\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  "\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  "\ 'hl+':     ['fg', 'Function'],
  "\ 'info':    ['fg', 'PreProc'],
  "\ 'prompt':  ['fg', 'Conditional'],
  "\ 'pointer': ['fg', 'Exception'],
  "\ 'marker':  ['fg', 'Keyword'],
  "\ 'spinner': ['fg', 'Label'],
  "\ 'header':  ['fg', 'Comment'] }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

let g:fzf_layout = { 'window': 'call OpenFloatingWin()' }

" key binding
if has('nvim-0.4')
  autocmd VimEnter * command! Yen3Files
    \ call fzf#vim#files(<q-args>,
      \ {'left': '50%',
      \  'options': '--reverse --prompt=""',
      \  'window': 'call OpenFloatingWin()'})

  autocmd VimEnter * command! Yen3Ag
    \ call fzf#vim#ag(<q-args>,
      \ {'left': '80%',
      \  'options': '-e --reverse --prompt=""',
      \  'window': 'call OpenFloatingWin()'})

  autocmd VimEnter * command! Yen3AgCursorWord
    \ call fzf#vim#ag(<q-args>,
      \ {'left': '80%',
      \  'options': '-e --reverse --prompt="" -q '. shellescape(expand('<cword>')),
      \  'window': 'call OpenFloatingWin()'})
else
  autocmd VimEnter * command! Yen3Files
    \ call fzf#vim#files(<q-args>,
      \ {'left': '50%',
      \  'options': '--reverse --prompt=""'})

  autocmd VimEnter * command! Yen3Ag
    \ call fzf#vim#ag(<q-args>,
      \ {'left': '80%',
      \  'options': '-e --reverse --prompt=""'})

  autocmd VimEnter * command! Yen3AgCursorWord
    \ call fzf#vim#ag(<q-args>,
      \ {'left': '80%',
      \  'options': '-e --reverse --prompt="" -q '. shellescape(expand('<cword>'))})
endif

noremap <silent><C-P> :Yen3Files<CR>
noremap <silent><leader>s :Yen3Ag<CR>
noremap <silent><leader>ss :Yen3AgCursorWord<CR>
noremap <silent><leader>b :Buffers<CR>

if has('nvim-0.4')
  " ref: http://liuchengxu.org/blog-cn/posts/make-fzf-great-again-via-floating-window/
  function! OpenFloatingWin()
    let height = &lines - 3
    let width = float2nr(&columns - (&columns * 2 / 10))
    let col = float2nr((&columns - width) / 2)

    let opts = {
          \ 'relative': 'editor',
          \ 'row': 0,
          \ 'col': 0,
          \ 'width': width * 3 / 4,
          \ 'height': height
          \ }

    let buf = nvim_create_buf(v:false, v:true)
    let win = nvim_open_win(buf, v:true, opts)

    call setwinvar(win, '&winhl', 'Normal:Pmenu')

    setlocal
          \ buftype=nofile
          \ nobuflisted
          \ bufhidden=hide
          \ nonumber
          \ norelativenumber
          \ signcolumn=no
  endfunction
endif
" }}}
" Unite Outline: {{{
let g:unite_enable_split_vertically = 1
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
let g:unite_enable_use_short_source_names = 1
"" outline
nnoremap <leader>o :Unite -start-insert outline<CR>
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
