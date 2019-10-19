command! -range Comment <line1>,<line2>call CcomenterOpr('r')
nnoremap <Leader>k :set operatorfunc=set operatorfunc=CcomenterOpr<cr>g@
nnoremap <Leader>kk :Comment<CR>
vnoremap <leader>k :<c-u>call CcomenterOpr(visualmode())<cr>

function! CcomentLines(firstLine, lastLine)
    for i in range(a:firstLine, a:lastLine)
        call cursor(i, 1)
        normal! 0i//
    endfor
endfunction

function! CcommentRegion(firstCol, firstLine, lastCol, lastLine)
    call cursor(a:firstLine, a:firstCol)
    execute("normal! i/*")
    let lastCol = a:lastCol
    if a:firstLine == a:lastLine
        let lastCol += 2
    endif
    call cursor(a:lastLine, lastCol)
    execute("normal! a*/")
endfunction

function! IsFullLines(firstCol, firstLine, lastCol, lastLine)
    if a:firstCol != 1
        return 0
    endif
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
        let isLineComment = IsFullLines(firstCol, firstLine, lastCol, lastLine)
    elseif isRange
        let isLineComment = 1
        let firstLine = a:firstline
        let lastLine = a:lastline
    else
        let firstLine = lPos
        let firstCol = cPos
        let lastLine = line("']")
        let lastCol = col("']")
        let isLineComment = IsFullLines(firstCol, firstLine, lastCol, lastLine)
    endif

    if isLineComment
        call CcomentLines(firstLine, lastLine)
    else
        call CcommentRegion(firstCol, firstLine, lastCol, lastLine)
    endif
    call cursor(lPos, cPos)
endfunction
