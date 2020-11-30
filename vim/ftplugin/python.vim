" Highlight: {{{
let python_highlight_all = 1
" }}}
" Indent: {{{
" set python indention
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
set autoindent
set fileformat=unix
" }}}
" Autocomplete: {{{
" let deoplete#sources#jedi#show_docstring = 0
let g:pymode_rope = 0

if g:yen3_auto_complete_selection == 1
  " Keymap for jedi-vim
  let g:jedi#goto_command = "<c-]>"
  let g:jedi#goto_assignments_command = "ga"
  let g:jedi#goto_definitions_command = "gd"
  let g:jedi#documentation_command = "K"
  let g:jedi#usages_command = "gu"
  let g:jedi#rename_command = "gr"
endif
" }}}
" Docs {{{

function! s:PyDoc()
    " Check if python is installed
    if !executable('python3') && !executable('python')
        echoerr 'python is not installed or not in your path.'
        return
    endif

    " If there is a word under the cursor try to use jedi - documentation
    " function to retrieve docs; otherwise use pydoc
    let object = expand('<cword>')
    if !empty(object)
        silent call jedi#show_documentation()
        return
    else
    " Note that here the  object should be entered without parenthesis, i.e
    " numpy.add and not numpy.add()
        let object = input('Enter object to view doc: ')
        if empty(object)
            return
        endif
    endif

    " Delete previous doc buffers
    silent! bdelete Py_doc
    silent! bdelete __doc__

    " Define settings for this new buffer and read/paste output from pydoc
    let compiler = 'python3'
    if !executable(compiler)
        let compiler = 'python'
    endif
    " Add space to compiler
    let compiler = compiler . ' '

    let pydoc_command = compiler . ' -m pydoc ' . object
    let output = split(system(pydoc_command), '\n')

    " If there is no documentation give error message
    if match(output[0] , '^no Python documentation') != -1
        redraw!
        echohl Error
        echo 'No Python docs found for `' . object . '`'
        echohl none
        return
    endif

    " If there is documentation create a buffer to dump output
    let height = len(output)
    execute 'silent botright new Py_doc'

    " Actually dump the output
    call append(line('$'), output)

    " Delete extra line at the end (only if it's empty), at the beginning,
    " remove extra indent and set buffer to nonmodifiable and filetype rst
    if getline(line('$')) ==# ''
        silent normal! Gdd
        let height = height - 1
    endif
    silent normal! ggdd
    silent normal! gg<G
    setlocal nomodifiable nomodified filetype=rst

    " Resize the buffer height
    if height > g:jedi#max_doc_height
        let height = g:jedi#max_doc_height
    endif
    execute height . ' wincmd _'

    " Mappings to quit this buffer easily and search for another object
    nnoremap <silent> <buffer> Q :bd!<CR>
    nnoremap <silent> <buffer>  <C-]> :call <SID>PyDoc()<CR>
    nnoremap <silent> <buffer> <S-k> :call <SID>PyDoc()<CR>
endfunction

augroup py_doc_rst
    au!
    " Allow also to search for another object in jedi docs
    au FileType rst if fnamemodify(bufname(''), ':t') ==# '''__doc__''' |
                \ nnoremap <silent> <buffer> K :call <SID>PyDoc()<CR> |
                \ nnoremap <silent> <buffer>  <C-]> :call <SID>PyDoc()<CR> |
                \ endif
augroup END

" }}}
" View Module {{{
" Credit: https://github.com/petobens/dotfiles/blob/master/vim/ftplugin/python/python_settings.vim


" Function to view a module source code
if !exists('*s:ViewPyModule()')
    function! s:ViewPyModule()
        if !exists(':Pyimport')
            echohl Error
            echo 'jedi-vim is not installed.'
            echohl none
            return
        endif
        let import = input('Enter module name: ')
        if empty(import)
            return
        endif
        execute 'Pyimport ' . import
    endfunction
endif

" }}}

" View module source code
nnoremap <buffer> <silent> <Leader>vm :call <SID>ViewPyModule()<CR>
nnoremap <buffer> <silent> <S-k> :call <SID>PyDoc()<CR>

" vim: ft=vim foldmethod=marker foldcolumn=1
