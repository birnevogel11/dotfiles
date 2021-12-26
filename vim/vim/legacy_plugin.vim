" zM: foldall
" GV: {{{
function! s:GVYankCommit()
    let commit_hash = matchstr(getline('.'), '-\d\+\s\zs\w*\ze\s')
    call setreg('+', commit_hash)
endfunction

function s:GVNextCommit()
  if winnr('$') > 1
    call search('^.*[a-z0-9]')
  endif
  normal o
endfunction

function s:GVPrevCommit()
  if winnr('$') > 1
    call search('^.*[a-z0-9]', 'b')
  endif
  normal o
endfunction

function s:GVOpen()
  :GV
  normal o
endfunction

function s:GVOpenCurrentFile()
  :GV!
  normal o
endfunction

autocmd FileType git setlocal nofoldenable

augroup ps_gv
  au!
  au FileType GV call s:GVKeyMapping()
augroup END

nnoremap <silent> <leader>gv :call <SID>GVOpen()<cr>
nnoremap <silent> <leader>gV :call <SID>GVOpenCurrentFile()<cr>

function s:GVKeyMapping()
  nmap <silent> <buffer> <C-y> :call <SID>GVYankCommit()<cr>

  nmap <silent> <buffer> j      :call <SID>GVNextCommit()<cr>
  nmap <silent> <buffer> k      :call <SID>GVPrevCommit()<cr>
endfunction
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
