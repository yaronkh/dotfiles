" Function to disable ALE for specific filenames in Python
function! DisableALEForSpecificFiles()
  if &filetype ==# 'python'
    " Add your specific filenames here
    let filenames = ['file1.py', 'file2.py']
    if expand('%:t') in filenames
      ALEDisable
    endif
  endif
endfunction

" Autocommand to call the function when opening a buffer
augroup DisableALEForFiles
  autocmd!
  autocmd BufRead,BufNewFile *.py call DisableALEForSpecificFiles()
augroup END
