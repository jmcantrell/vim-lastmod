" Filename:      lastmod.vim
" Description:   Updates a last modified timestamp when writing a file
" Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
" Last Modified: Sat 2011-05-07 21:55:10 (-0400)

if exists('g:lastmod_loaded') || &cp
    finish
endif

let g:lastmod_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:lastmod_lines')
    let g:lastmod_lines = 20
endif

if !exists('g:lastmod_format')
    let g:lastmod_format = '%a %Y-%m-%d %H:%M:%S (%z)'
endif

if !exists('g:lastmod_prefix')
    let g:lastmod_prefix = 'Last Modified: '
endif

if !exists('g:lastmod_suffix')
    let g:lastmod_suffix = ''
endif

if !exists('g:lastmod_commented')
    let g:lastmod_commented = 1
endif

function! s:Trim(value)
    return substitute(a:value, '^\s\+\|\s\+$', '', '')
endfunction

function! s:Squeeze(value)
    return s:Trim(substitute(a:value, '\s\+', ' ', 'g'))
endfunction

function! s:LastModUpdate()
    if &modified
        let save_cursor = getpos('.')
        let n = min([g:lastmod_lines, line('$')])
        let timestamp = strftime(g:lastmod_format)
        let fmt = g:lastmod_prefix.'%s'.g:lastmod_suffix
        if g:lastmod_commented
            let fmt = printf(&cms, ' '.fmt.' ')
        endif
        let fmt = s:Squeeze(fmt)
        keepjumps silent exe '1,'.n.'s%^\(\s*\)'.printf(fmt, '.*').'\(.*\)$%\1'.substitute(printf(fmt, timestamp), '%', '\%', 'g').'\2%e'
        call histdel('search', -1)
        call setpos('.', save_cursor)
    endif
endfunction

command! -bar LastModUpdate call s:LastModUpdate()

autocmd BufWritePre * LastModUpdate

let &cpo = s:save_cpo
