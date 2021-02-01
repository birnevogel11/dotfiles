if g:yen3_search_selection == 1
" Denite {{{
nnoremap <silent><C-P>       :Denite file/rec<cr>
nnoremap <silent><leader>o   :Denite outline<cr>
nnoremap <silent><leader>do  :Denite unite:outline<cr>
nnoremap <silent><leader>dm  :Denite file_mru<cr>
nnoremap <silent><leader>db  :Denite buffer<cr>
nnoremap <silent><leader>ds  :Denite grep:::`expand('<cword>')`
      \ -auto-action=preview -winrow=15 -winheight=20 -no-start-filter<cr>
nnoremap <silent><leader>dS  :Denite grep
      \ -auto-action=preview  -winrow=15 -winheight=20 -no-vertical_preview<cr>
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
nnoremap <silent><leader>dj  :Denite jump<cr>
nnoremap <silent><leader>dk  :Denite mark<cr>

let s:denite_win_width_percent = 0.7
let s:denite_win_height_percent = 1

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
" call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
        " \ ['.git/', '__pycache__/', '.mypy_cache/', 'venv/',  'man://*',
        " \  '*.pyc', '.ccls-cache/', '*.o', '*.d', '.eggs/', '.coverage*',
        " \  '.pytest_cache/', '*.egg-info/', 'build/', 'Debug/', 'build_test/',
        " \  '.tox/', 'thirdparties/', 'build-linux/', '.clangd/',
        " \  '.stack-work/'])

" Buffer source settings
call denite#custom#var('buffer', 'date_format', '')

" Neomru
let g:neomru#file_mru_limit = 750
let g:neomru#time_format = ''
let g:neomru#do_validate = 1
let g:neomru#update_interval = 300

if executable('rg')
  call denite#custom#var('file/rec', 'command',
      \ ['rg', '--files', '--hidden', '--vimgrep', '--glob', '!.o'])
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
if g:yen3_file_explorer == 1
" Defx: {{{
" Git
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
endif

call defx#custom#option('_', {
  \ 'show_ignored_files': 1,
  \ 'root_marker': '﬌ ',
  \ 'floating_preview': 1,
  \ 'vertical_preview': 1,
  \ 'preview_width': 75,
  \ 'preview_height': 30
  \ })

call defx#custom#column('git', 'indicators', {
  \ 'Modified'  : '✚',
  \ 'Staged'    : '●',
  \ 'Untracked' : '?',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : 'שּׁ',
  \ 'Deleted'   : '✖',
  \ 'Unknown'   : '?'
  \ })

if g:yen3_enable_dev_icons == 1
  nnoremap <silent><leader>f :Defx -columns=git:mark:icons:filename:type:size<cr>
  nnoremap <silent> <Leader>fr :Defx -resume -columns=git:mark:icons:filename:type:size<cr>
else
  nnoremap <silent><leader>f :Defx -columns=git:mark:filename:type:size<cr>
  nnoremap <silent> <Leader>fr :Defx -resume -columns=git:mark:filename:type:size<cr>
endif


function! s:DefxUpdatePreview(dir, lines) abort
    execute 'normal! ' . a:lines . a:dir
    " call defx#call_action('preview')
    for nr in range(1, winnr('$'))
        if getwinvar(nr, '&previewwindow') == 1
            call defx#call_action('preview')
            break
        endif
    endfor
  endfunction

" Ref: https://github.com/petobens/dotfiles/blob/master/vim/init.vim
augroup ps_defx
    au!
    " au FileType defx call s:defx_settings()
    au FileType defx call s:defx_my_settings()
    " au FileType defx setlocal relativenumber
    au User defx-preview setlocal number winblend=4
augroup END

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
     nnoremap <silent><buffer><expr> P defx#do_action('preview')
     nnoremap <silent><buffer> j :<C-u>call <SID>DefxUpdatePreview('j', v:count1)<CR>
     nnoremap <silent><buffer> k :<C-u>call <SID>DefxUpdatePreview('k', v:count1)<CR>
     " nnoremap <silent><buffer><expr> j
    " \ line('.') == line('$') ? 'gg' : 'j'
     " nnoremap <silent><buffer><expr> k
    " \ line('.') == 1 ? 'G' : 'k'
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
elseif g:yen3_file_explorer == 2
" Fern: {{{
function! s:init_fern() abort
  " Use 'select' instead of 'edit' for default 'open' action
  nmap <buffer>q <C-O>
  nmap <buffer>gq <C-O>
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END


nnoremap <silent><leader>f :Fern .<cr>
nnoremap <silent><leader>fr :Fern . -reveal=%<cr>
nnoremap <silent><leader>ff :Fern . -drawer<cr>
" }}}
endif

" vim: ft=vim foldmethod=marker foldcolumn=1
