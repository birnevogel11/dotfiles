if g:yen3_search_selection == 1
  " Fzf: {{{
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

  noremap <silent><C-P> :Yen3Files<cr>
  noremap <silent><leader>ds :Yen3Ag<cr>
  noremap <silent><leader>dss :Yen3AgCursorWord<cr>
  noremap <silent><leader>db :Buffers<cr>

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
  nnoremap <leader>do :Unite -start-insert outline<cr>
  " }}}
elseif g:yen3_search_selection == 2
" Denite {{{
nnoremap <silent><C-P>       :Denite file/rec<cr>
nnoremap <silent><leader>o   :Denite outline<cr>
nnoremap <silent><leader>do  :Denite unite:outline<cr>
nnoremap <silent><leader>dm  :Denite file_mru<cr>
nnoremap <silent><leader>db  :Denite buffer<cr>
nnoremap <silent><leader>ds  :Denite grep:::`expand('<cword>')`
      \ -auto-action=preview -no-start-filter<cr>
nnoremap <silent><leader>dS  :Denite grep
      \ -auto-action=preview -no-vertical_preview<cr>
nnoremap <silent><leader>dy  :Denite neoyank<cr>
nnoremap <silent><leader>dq  :Denite
      \ -post-action=suspend -auto-action=preview -no-start-filter
      \ quickfix<cr>
nnoremap <silent><leader>bm  :Denite -no-start-filter dirmark<cr>
nnoremap <silent><leader>dr  :Denite -resume<cr>
nnoremap <silent><leader>dl  :DeniteCursorWord -auto-action=preview
            \ line:forward -no-start-filter<cr>
nnoremap <silent><leader>dL  :Denite line:forward<cr>
nnoremap <silent><leader>dh  :Denite help<cr>

let s:denite_win_width_percent = 0.5
let s:denite_win_height_percent = 0.9

call denite#custom#option('default', {
            \ 'auto_resume': 1,
            \ 'statusline': 0,
            \ 'split': 'floating',
            \ 'wincol': 0,
            \ 'winrow': 0,
            \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
            \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
            \ 'highlight_prompt': 'Function',
            \ 'highlight_matched_char': 'Operator',
            \ 'highlight_matched_range': 'None',
            \ 'prompt': '> ',
            \ 'vertical-preview': 1,
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
        \ ['.git/', '__pycache__/', 'venv/',  'man://*',
        \  '*.pyc', '.ccls-cache/', '*.o', '.eggs/', '.coverage*',
        \  '*.egg-info/', 'build/', 'Debug/', 'build_test/',
        \  '.tox/', 'thirdparties/', 'build-linux/', '.clangd/'])

" Buffer source settings
call denite#custom#var('buffer', 'date_format', '')

" Neomru
let g:neomru#file_mru_limit = 750
let g:neomru#time_format = ''
let g:neomru#do_validate = 1
let g:neomru#update_interval = 300

if executable('rg')
  call denite#custom#var('file_rec', 'command',
      \ ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts',
          \ ['--smart-case', '--vimgrep', '--no-heading'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
endif

augroup ps_denite_setup
    au!
    au FileType denite call s:denite_my_settings()
    au FileType denite-filter call s:denite_filter_my_settings()
    au FileType denite-filter
       \ call deoplete#custom#buffer_option('auto_complete', v:false)
    au FileType denite-filter setlocal nocursorline
augroup END

function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <cr>    denite#do_map('do_action')
  nnoremap <silent><buffer><expr> <C-v>   denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> <C-s>   denite#do_map('do_action', 'split')
  nnoremap <silent><buffer><expr> <c-t>   denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> <C-r>   denite#do_map('redraw')
  nnoremap <silent><buffer><expr> <C-x>   denite#do_map('choose_action')
  nnoremap <silent><buffer><expr> d       denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p       denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q       denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-c>   denite#do_map('quit')
  nnoremap <silent><buffer><expr> i       denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
endfunction

function! s:denite_filter_my_settings() abort
    inoremap <silent><buffer><expr> <C-c> denite#do_map('quit')
    inoremap <silent><buffer><expr> <ESC> denite#do_map('quit')
    nnoremap <silent><buffer><expr> <C-c> denite#do_map('quit')
    nnoremap <silent><buffer><expr> <ESC> denite#do_map('quit')
    nnoremap <silent><buffer><expr> q     denite#do_map('quit')
    imap     <silent><buffer>       <tab> <Plug>(denite_filter_quit)
    inoremap <silent><buffer><expr> <C-r> denite#do_map('redraw')

    inoremap <silent><buffer><expr> <cr>  denite#do_map('do_action')
    inoremap <silent><buffer><expr> <c-t> denite#do_map('do_action', 'tabopen')
    inoremap <silent><buffer><expr> <c-v> denite#do_map('do_action', 'vsplit')
    inoremap <silent><buffer><expr> <c-s> denite#do_map('do_action', 'split')
    inoremap <silent><buffer><expr> <C-x> denite#do_map('choose_action')
    inoremap <silent><buffer> <C-j>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('j', 1)<cr>
    inoremap <silent><buffer> <C-n>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('j', 1)<cr>
    inoremap <silent><buffer> <C-k>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('k', 1)<cr>
    inoremap <silent><buffer> <C-p>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('k', 1)<cr>
    inoremap <silent><buffer> <C-u>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('k', 12)<cr>
    inoremap <silent><buffer> <C-d>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('j', 12)<cr>
    inoremap <silent><buffer> <up>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('k', 1)<cr>
    inoremap <silent><buffer> <down>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('j', 1)<cr>
    inoremap <silent><buffer><PageUp>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('k', 12)<cr>
    inoremap <silent><buffer><PageDown>
                \ <Esc>:call <SID>DeniteMoveCursorCandidateWindow('j', 12)<cr>
endfunction

function! s:DeniteMoveCursorCandidateWindow(dir, lines) abort
    call win_gotoid(win_findbuf(g:denite#_filter_parent)[0])
    execute 'normal! ' . a:lines . a:dir
    call win_gotoid(g:denite#_filter_winid)
    startinsert!
endfunction
" }}}
endif
" Defx: {{{
if g:yen3_enable_dev_icons == 1
  call defx#custom#option('_', {
            \ 'show_ignored_files': 1,
            \ 'columns': 'mark:indent:icon:filename:icons:size:git',
            \ 'root_marker': '﬌ '
            \ })

  call defx#custom#column('mark', {
              \ 'readonly_icon': '',
              \ 'selected_icon': '',
              \ })
  call defx#custom#column('indent', { 'indent': '  '})
  call defx#custom#column('icon', {
              \ 'root_icon': ' ',
              \ 'directory_icon': '',
              \ 'opened_icon': '',
              \ })
  call defx#custom#column('filename', {
              \ 'min_width': 23,
              \ 'max_width': 23,
              \ })
  call defx#custom#column('time', {'format': '%Y%m%d %H:%M'})

  " Devicons
  let g:defx_icons_enable_syntax_highlight = 0
  let g:defx_icons_extensions = {
              \ 'tex': {'icon': ''},
              \ 'bib': {'icon': ''},
              \ 'gitcommit': {'icon': ''},
              \ 'pdf': {'icon': ''},
              \ 'r': {'icon': 'ﳒ'},
              \ 'R': {'icon': 'ﳒ'},
              \ }
  let g:defx_icons_exact_matches = {
              \ '.gitconfig': {'icon': ''},
              \ '.gitignore': {'icon':''},
              \ 'bashrc': {'icon': ''},
              \ '.bashrc': {'icon': ''},
              \ 'bash_profile': {'icon':''},
              \ '.bash_profile': {'icon':''},
              \ }
  let g:defx_icon_exact_dir_matches = {
              \ '.git'     : {'icon': ''},
              \ 'Desktop'  : {'icon': ''},
              \ 'Documents': {'icon': ''},
              \ 'Downloads': {'icon': ''},
              \ 'Dropbox'  : {'icon': ''},
              \ 'Music'    : {'icon': ''},
              \ 'Pictures' : {'icon': ''},
              \ 'Public'   : {'icon': ''},
              \ 'Templates': {'icon': ''},
              \ 'Videos'   : {'icon': ''},
              \ }

  " Git
  call defx#custom#column('git', 'indicators', {
    \ 'Modified'  : '✚',
    \ 'Staged'    : '●',
    \ 'Untracked' : '?',
    \ 'Renamed'   : '➜',
    \ 'Unmerged'  : 'שּׁ',
    \ 'Deleted'   : '✖',
    \ 'Unknown'   : '?'
    \ })

  let g:defx_icons_enable_syntax_highlight=1
  nnoremap <silent><leader>f :Defx<cr>
  nnoremap <silent><leader>ff :Defx
        \ -split=vertical -winwidth=40 -direction=topleft<cr>
else
  nnoremap <silent><leader>f :Defx -columns=indent:filename:type<cr>
  " nnoremap <silent><leader>ff :Defx
        " \ -split=vertical -winwidth=40 -direction=topleft
        " \ -columns=indent:filename:type<cr>
endif
nnoremap <silent> <Leader>fr :Defx -resume<cr>

" Ref: https://github.com/petobens/dotfiles/blob/master/vim/init.vim
autocmd FileType defx call s:defx_my_settings()
    function! s:defx_my_settings() abort
     " Define mappings
      nnoremap <silent><buffer><expr> <cr>
     \ defx#do_action('open')
      nnoremap <silent><buffer><expr> s
     \ defx#do_action('multi', [['drop', 'split'], 'quit'])
      nnoremap <silent><buffer><expr> v
     \ defx#do_action('multi', [['drop', 'vsplit'], 'quit'])
      nnoremap <silent><buffer><expr> c
     \ defx#do_action('copy')
      nnoremap <silent><buffer><expr> m
     \ defx#do_action('move')
      nnoremap <silent><buffer><expr> p
     \ defx#do_action('paste')
      nnoremap <silent><buffer><expr> l
     \ defx#do_action('open')
      nnoremap <silent><buffer><expr> K
     \ defx#do_action('new_directory')
      nnoremap <silent><buffer><expr> N
     \ defx#do_action('new_file')
      nnoremap <silent><buffer><expr> d
     \ defx#do_action('remove')
      nnoremap <silent><buffer><expr> r
     \ defx#do_action('rename')
      nnoremap <silent><buffer><expr> x
     \ defx#do_action('execute_system')
      nnoremap <silent><buffer><expr> yy
     \ defx#do_action('yank_path')
      nnoremap <silent><buffer><expr> .
     \ defx#do_action('toggle_ignored_files')
      nnoremap <silent><buffer><expr> h
     \ defx#do_action('cd', ['..'])
      nnoremap <silent><buffer><expr> ~
     \ defx#do_action('cd')
      nnoremap <silent><buffer><expr> q
     \ defx#do_action('quit')
      nnoremap <silent><buffer><expr> <Space>
     \ defx#do_action('toggle_select') . 'j'
      nnoremap <silent><buffer><expr> *
     \ defx#do_action('toggle_select_all')
      nnoremap <silent><buffer><expr> j
     \ line('.') == line('$') ? 'gg' : 'j'
      nnoremap <silent><buffer><expr> k
     \ line('.') == 1 ? 'G' : 'k'
      nnoremap <silent><buffer><expr> <C-r>
     \ defx#do_action('redraw')
      nnoremap <silent><buffer><expr> <C-g>
     \ defx#do_action('print')
      nnoremap <silent><buffer><expr> cd
     \ defx#do_action('change_vim_cwd')
      nnoremap <silent><buffer><expr> <Leader>th
     \ defx#do_action('toggle_ignored_files')
     " Tree editing, opening and closing
      nnoremap <silent><buffer><expr> e
     \ defx#is_directory() ? defx#do_action('open_tree') :
     \ defx#do_action('multi', ['drop', 'quit'])
      nnoremap <silent><buffer><expr> zo defx#do_action('open_tree')
      nnoremap <silent><buffer><expr> zc defx#do_action('close_tree')
      nnoremap <silent><buffer><expr> zr defx#do_action('open_tree_recursive',
     \ [3])
    endfunction
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
