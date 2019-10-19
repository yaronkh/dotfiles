command! -range Comment <line1>,<line2>call CcomenterOpr('r')
nnoremap <Leader>k :set operatorfunc=set operatorfunc=CcomenterOpr<cr>g@
nnoremap <Leader>kk :Comment<CR>
vnoremap <leader>k :<c-u>call CcomenterOpr(visualmode())<cr>

function! CcomentLines(firstLine, firstCol, lastLine)
    call setpos('.', [0, a:firstLine, a:firstCol, 0])
    normal! i//
    for i in range(a:firstLine + 1, a:lastLine)
        call cursor(i, 1)
        normal! 0i//
    endfor
endfunction

function! CcommentRegion(firstCol, firstLine, lastCol, lastLine)
    call cursor(a:firstLine, a:firstCol)
    normal! i/*
    let lastCol = a:lastCol
    if a:firstLine == a:lastLine
        let lastCol += 2
    endif
    call cursor(a:lastLine, lastCol)
    normal! a*/
    let inCommentRange = 0
    for l in range(a:firstLine, a:lastLine)
        let c1 = 1
        let c2 = col([l, '$'])
        if l == a:firstLine
            let c1 = a:firstCol + 2
        endif
        if l == a:lastLine
            let c2 = a:lastCol
        endif
        let inCommentRange = CcEscape(l, c1, c2, inCommentRange)
    endfor
    if inCommentRange
        normal! la/*
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
            normal! i*/
        elseif tc == '*/'
            let rv = 0
            normal! la/*
            normal! h
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

function! CcomenterOpr(mode) range
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
        let firstLine = a:firstline
        let lastLine = a:lastline
    else
        let firstLine = lPos
        let firstCol = cPos
        let lastLine = line("']")
        let lastCol = col("']")
        let isLineComment = IsFullLines(lastCol, lastLine)
    endif

    if isLineComment
        call CcomentLines(firstLine, firstCol, lastLine)
    else
        call CcommentRegion(firstCol, firstLine, lastCol, lastLine)
    endif
    call cursor(lPos, cPos)
endfunction
