command! -range Comment <line1>,<line2>call CcomenterOpr('r')
nnoremap <Leader>k :set operatorfunc=set operatorfunc=CcomenterOpr<cr>g@
nnoremap <Leader>kk :Comment<CR>
vnoremap <leader>k :<c-u>call CcomenterOpr(visualmode())<cr>

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
        echom "test=". (a:mode == 'V')
        let bIgCase = &ignorecase
        set noignorecase
        let isLineComment = (a:mode == 'V' || cPos == 1 && lastCol == 1)
        let &ignorecase = bIgCase
    elseif isRange
        let isLineComment = 1
        let firstLine = a:firstline
        let lastLine = a:lastline
    else
        let firstLine = lPos
        let firstCol = cPos
        execute "normal! `]"
        let lastLine = line(".")
        let lastCol = col(".")
        let isLineComment = (cPos == 1 && lastCol == 1)
    endif

    if isLineComment
        for i in range(firstLine, lastLine)
            call cursor(i, 1)
            normal! 0i//
        endfor
    else
        call cursor(firstLine, firstCol)
        execute("normal! i/*")
        if firstLine == lastLine
            let lastCol = lastCol + 2
        endif
        call cursor(lastLine, lastCol)
        execute("normal! a*/")
    endif
    call cursor(lPos, cPos)
endfunction
