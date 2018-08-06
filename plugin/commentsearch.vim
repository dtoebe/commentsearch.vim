" commentsearch.vim - Search TODO, FIXME and XXX tasks With exluded dirs
" Maintainer:   Daniel Toebe <https://dtoebe.com>
" Version:      0.1

if exists("g:commentsearch_types_loded") || &cp || v:version < 700
    finish
endif

let g:commentsearch_types_loded=1

if !exists("g:commentsearch_types_list")
    let g:commentsearch_types_list=['TODO', 'FIXME', 'XXX']
endif

if !exists("g:commentsearch_excludedirs_list")
    let g:commentsearch_excludedirs_list=['.git', 'vendor', 'node_modules']
endif

" prepstatement joins commentsearch_types_list to a single string and adds ()
" if needed {{{
function s:prepstatement()
    let l:types=join(g:commentsearch_types_list, '\|')
    if len(g:commentsearch_types_list) >1
        let l:types='\(' . l:types . '\)'
    endif

    return l:types
endfunction
" }}}

" CommentSearchVimGrep takes the path to search runs it against vimgrep and
" outputs it in a QuickFix window {{{
function s:CommentSearchVimGrep(expr)
    if a:expr
        echom "please add a directory: **/*.go"
        return ''
    endif

    execute 'vimgrep /' . s:prepstatement() . '/gj ' .a:expr

    cwindow
endfunction
" }}}

" CommentSearchVimGrepAdd takes the path to search runs it against vimgrepadd and
" outputs it in a QuickFix window {{{
function s:CommentSearchVimGrepAdd(expr)
    if a:expr
        echom "please add a directory: **/*.go"
        return ''
    endif

    execute 'vimgrepadd /' . s:prepstatement() . '/gj ' .a:expr

    cwindow
endfunction
" }}}

" CommentSearchGrep takes the path to search runs it against grep and
" checks for exclude-dir outputs it in a QuickFix window {{{
function s:CommentSearchGrep(expr)
if a:expr
        echom "please add a directory: **/*.go"
        return ''
    endif

    let l:exdir=''
    if len(g:commentsearch_excludedirs_list) > 0
        let l:exdir = '--exclude-dir=' . join(g:commentsearch_excludedirs_list, ' --exclude-dir=')
    endif

    let l:types=join(g:commentsearch_types_list, '\|')

    execute 'silent :grep -ERn ' . l:exdir . ' "' . l:types . '" ' . a:expr
    cwindow
endfunction
" }}}

" CommentSearchGrepAdd takes the path to search runs it against grepadd and
" checks for exclude-dir outputs it in a QuickFix window {{{
function s:CommentSearchGrepAdd(expr)
if a:expr
        echom "please add a directory: **/*.go"
        return ''
    endif

    let l:exdir=''
    if len(g:commentsearch_excludedirs_list) > 0
        let l:exdir = '--exclude-dir=' . join(g:commentsearch_excludedirs_list, ' --exclude-dir=')
    endif

    let l:types=join(g:commentsearch_types_list, '\|')

    execute 'silent :grepadd -ERn ' . l:exdir . ' "' . l:types . '" ' . a:expr
    cwindow
endfunction
" }}}

command -nargs=1 CmtSearch call s:CommentSearchVimGrep('<args>')
command -nargs=1 CmtSearchAdd call s:CommentSearchVimGrepAdd('<args>')
command -nargs=1 CmtSearchEx call s:CommentSearchGrep('<args>')
command -nargs=1 CmtSearchExAdd call s:CommentSearchGrepAdd('<args>')
