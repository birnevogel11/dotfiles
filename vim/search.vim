if g:yen3_search_selection == 1
  " Fzf: {{{
  if has("gui_running") && has("mac")
  let g:fzf_launcher = "/Users/yen3/.personal_scripts/fzf_macvim_start.sh %s"
  endif

  " This is the default extra key bindings
  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }

  " [Buffers] Jump to the existing window if possible
  let g:fzf_buffers_jump = 1

  " [[B]Commits] Customize the options used by 'git log':
  let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

  let g:fzf_layout = { 'window': 'call OpenFloatingWin()' }

  " key binding
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

  " autocmd VimEnter * command! Yen3AgCursorWord
    " \ call fzf#vim#ag(<q-args>,
      " \ {'left': '80%',
      " \  'options': '-e --reverse --prompt="" -q '. shellescape(expand('<cword>')),
      " \  'window': 'call OpenFloatingWin()'})

  noremap <silent><C-P> :Yen3Files<CR>
  noremap <silent><leader>ds :Yen3Ag<CR>
  noremap <silent><leader>dss :Yen3AgCursorWord<CR>
  noremap <silent><leader>db :Buffers<CR>

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
  " }}}
  " Unite Outline: {{{
  let g:unite_enable_split_vertically = 1
  let g:unite_enable_ignore_case = 1
  let g:unite_enable_smart_case = 1
  let g:unite_enable_use_short_source_names = 1
  "" outline
  nnoremap <leader>do :Unite -start-insert outline<CR>
  " }}}
elseif g:yen3_search_selection == 2
" Denite {{{
noremap <silent><C-P> :Denite file/rec<CR>
noremap <silent><leader>dm :Denite file_mru<CR>
noremap <silent><leader>db :Denite buffer<CR>
noremap <silent><leader>ds :Denite grep<CR>
noremap <silent><leader>dss :DeniteCursorWord grep<CR>

call denite#custom#option('default', {
            \ 'auto_resume': 1,
            \ 'statusline': 0,
            \ 'split': 'no',
            \ 'prompt': '>',
            \ 'source_names': 'short',
            \ 'highlight_prompt': 'Function',
            \ 'highlight_matched_char': 'Operator',
            \ 'highlight_matched_range': 'None',
            \ 'vertical_preview': 1,
            \ 'start_filter': 1,
            \ 'filter_updatetime': 100,
            \ })

" Fruzzy matcher
let g:fruzzy#usenative = 0
let g:fruzzy#sortonempty = 0
call denite#custom#source('_', 'matchers', ['matcher/fruzzy',
        \ 'matcher/ignore_globs'])

" Other matcher and sorting options
call denite#custom#source('line', 'matchers', ['matcher/regexp'])
call denite#custom#source('default', 'sorters', ['sorter/rank'])

" Ignore some files and directories
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
        \ ['.git/', '__pycache__/', 'venv/',  'man://*', '*.pyc',])

" Buffer source settings
call denite#custom#var('buffer', 'date_format', '')

" Neomru
let g:neomru#file_mru_limit = 750
let g:neomru#time_format = ''
let g:neomru#do_validate = 1
let g:neomru#update_interval = 300

" Use fd for file_rec and ripgrep for grep
if executable('fd')
    call denite#custom#var('file/rec', 'command',
        \ ['fd', '--type', 'f', '--follow', '--hidden', '--exclude', '.git',
        \ ''])
    call denite#custom#var('directory_rec', 'command',
        \ ['fd', '--type', 'd', '--follow', '--hidden', '--exclude', '.git',
        \ ''])
    " Define alias that don't ignore vcs files
    call denite#custom#alias('source', 'file/rec/noignore', 'file/rec')
    call denite#custom#var('file/rec/noignore', 'command',
        \ ['fd', '--type', 'f', '--follow', '--hidden', '--exclude', '.git',
        \ '--no-ignore-vcs', ''])
    call denite#custom#alias('source', 'directory_rec/noignore',
        \ 'directory_rec')
    call denite#custom#var('directory_rec/noignore', 'command',
        \ ['fd', '--type', 'd', '--follow', '--hidden', '--exclude', '.git',
        \ '--no-ignore-vcs', ''])
endif
if executable('ag')
  call denite#custom#var('grep', 'command', ['ag'])
  call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
endif

autocmd FileType denite call s:denite_my_settings()

function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()

function! s:denite_filter_my_settings() abort
    imap <silent><buffer> <tab> <Plug>(denite_filter_quit)
    inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
    inoremap <silent><buffer><expr> <c-t>
                \ denite#do_map('do_action', 'tabopen')
    inoremap <silent><buffer><expr> <c-v>
                \ denite#do_map('do_action', 'vsplit')
    inoremap <silent><buffer><expr> <c-x>
                \ denite#do_map('do_action', 'split')
    inoremap <silent><buffer><expr> <esc>
                \ denite#do_map('quit')
    inoremap <silent><buffer> <C-j>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('j', 1)<CR>
    inoremap <silent><buffer> <C-n>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('j', 1)<CR>
    inoremap <silent><buffer> <C-k>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('k', 1)<CR>
    inoremap <silent><buffer> <C-p>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('k', 1)<CR>
    inoremap <silent><buffer> <C-u>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('k', 12)<CR>
    inoremap <silent><buffer> <C-d>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('j', 12)<CR>
    inoremap <silent><buffer> <up>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('k', 1)<CR>
    inoremap <silent><buffer> <down>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('j', 1)<CR>
    inoremap <silent><buffer><PageUp>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('k', 12)<CR>
    inoremap <silent><buffer><PageDown>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('j', 12)<CR>
endfunction

function! s:DeniteMoveCursorCandidateWindow(dir, lines) abort
    call win_gotoid(win_findbuf(g:denite#_filter_parent)[0])
    execute 'normal! ' . a:lines . a:dir
    call win_gotoid(g:denite#_filter_winid)
    startinsert!
endfunction

" }}}
endif

" vim: ft=vim foldmethod=marker foldcolumn=1
