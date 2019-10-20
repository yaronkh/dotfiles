command! -range Comment <line1>,<line2>call CcomenterOpr('r')
nnoremap <Leader>k :set operatorfunc=set operatorfunc=CcomenterOpr<cr>g@
nnoremap <Leader>kk :Comment<CR>
vnoremap <leader>k :<c-u>call CcomenterOpr(visualmode())<cr>

command! -range Uncomment <line1>,<line2>call CuncommenterOpr('r')
nnoremap <Leader>u :set operatorfunc=set operatorfunc=CuncommenterOpr<cr>g@
nnoremap <Leader>uu :Uncomment<CR>
vnoremap <leader>u :<c-u>call CuncommenterOpr(visualmode())<cr>

function! CcomentLines(firstLine, firstCol, lastLine)
    call setpos('.', [0, a:firstLine, a:firstCol, 0])
    normal! i//
    for i in range(a:firstLine + 1, a:lastLine)
        call cursor(i, 1)
        normal! 0i//
    endfor
endfunction

function! CuncommentLines(firstLine, firstCol, lastLine)
    call setpos('.', [0, a:firstLine, a:firstCol, 0])
    let lines = getline(a:firstLine, a:lastLine)
    let linestr = lines[0]
    if linestr[a:firstCol - 1: a:firstCol] == '//'
       if a:firstCol == 1
           let linestr = linestr[2:]
       else
           let linestr = linestr[:a:firstCol - 2] . linestr[a:firstCol + 1:]
       endif
    endif
    call setline(a:firstLine, linestr)
    let i = a:firstLine + 1
    for l in lines[1:]
        let ll = substitute(l, '^\s*//', "", 'g')
        call setline(i, ll)
        let i += 1
    endfor
endfunction

function! IsAtCommentRegion()
    let pos = getpos('.')
    let lastend = search('\*/', 'b')
    if lastend > 0
        let lastEndPos = getpos('.')
    endif
    call setpos('.', pos)
    let laststart = search('/\*', 'b')
    if laststart > 0
        let lastStartPos = getpos('.')
    endif
    call setpos('.', pos)
    if laststart > 0
        return (laststart > lastend || laststart == lastend && lastStartPos[2] > lastEndPos[2])
    endif
    return 0
endfunction

function! CcommentRegion(firstCol, firstLine, lastCol, lastLine)
    call cursor(a:firstLine, a:firstCol)
    let inCommentRange = IsAtCommentRegion()
    if inCommentRange
        normal! i(*
    else
        normal! i/*
    endif
    let lastCol = a:lastCol
    if a:firstLine == a:lastLine
        let lastCol += 2
    endif
    for l in range(a:firstLine, a:lastLine)
        let c1 = 1
        let c2 = col([l, '$'])
        if l == a:firstLine
            let c1 = a:firstCol + 2
        endif
        if l == a:lastLine
            let c2 = lastCol
        endif
        let inCommentRange = CcEscape(l, c1, c2, inCommentRange)
    endfor
    call cursor(a:lastLine, lastCol)
    if inCommentRange
        normal! a*)
    else
        normal! a*/
    endif
endfunction

function! CcEscape(cline, scol, send, inCommentRange)
    let linestr = getline(a:cline)
    call cursor(a:cline, a:scol)
    let rv = a:inCommentRange
    for c in range(a:scol, a:send)
        let tc = linestr[c - 1: c]
        if tc == '/*'
            let rv = 1
            normal! R(*
            normal! 2h
        elseif tc == '*/'
            let rv = 0
            normal! R*)
            normal 2h
        endif
        normal! l
    endfor
    return rv
endfunction

function! IsFullLines( lastCol, lastLine)
    let pos = getpos('.')
    call cursor(a:lastLine, 999999)
    let col = col('$')
    let rv = (col == a:lastCol)
    call setpos(".", pos)
    return rv
endfunction

function! GetOprParams(mode, firstl, lastll)
    let isVisual = a:mode =~ '[vsx]'
    let isRange = a:mode == 'r'
    let lPos = line(".")
    let cPos = col(".")

    if isVisual
        let firstLine = line("'<")
        let lastLine = line("'>")
        let firstCol = col("'<")
        let lastCol = col("'>") - (&selection == 'exclusive' ? 1 : 0)
        let bIgCase = &ignorecase
        let isLineComment = IsFullLines(lastCol, lastLine)
    elseif isRange
        let isLineComment = 1
        let firstLine = a:firstl
        let lastLine = a:lastll
        let firstCol = 1
        let lastCol = 1
    else
        let firstLine = lPos
        let firstCol = cPos
        let lastLine = line("']")
        let lastCol = col("']")
        let isLineComment = IsFullLines(lastCol, lastLine)
    endif
    return { "lPos" : lPos, "cPos" : cPos, "firstLine" : firstLine, "lastLine" : lastLine, "firstCol" : firstCol, "lastCol" : lastCol, "isLineComment" : isLineComment}
endfunction

function! CcomenterOpr(mode) range
    let params = GetOprParams(a:mode, a:firstline, a:lastline)

    if params.isLineComment
        call CcomentLines(params.firstLine, params.firstCol, params.lastLine)
    else
        call CcommentRegion(params.firstCol, params.firstLine, params.lastCol, params.lastLine)
    endif
    call cursor(params.lPos, params.cPos)
endfunction

function! CuncommenterOpr(mode) range
    let params = GetOprParams(a:mode, a:firstline, a:lastline)
    if params.isLineComment
        call CuncommentLines(params.firstLine, params.firstCol, params.lastLine)
    else
        echom "not implemented"
        "call CuncommentRegion(params.firstCol, params.firstLine, params.lastCol, params.lastLine)
    endif

    call cursor(params.lPos, params.cPos)
endfunction
