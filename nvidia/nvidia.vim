" Function to disable ALE for specific filenames in Python
function! DisableALEForSpecificFiles()
        " Add your specific filenames here
        let filenames = ['CMSocket.py', 'managementCM.py']
        "if expand('%:t') in filenames
        "        let b:ale_sign_warning = ''
        "        let b:ale_echo_msg_warning_str = ''
        "        let b:ale_virtualtext_warning = 0
        "        ALEDisable
        "endif
endfunction

" Autocommand to call the function when opening a buffer
augroup DisableALEForFiles
        autocmd!
        autocmd BufReadPost,BufNewFile *.py call DisableALEForSpecificFiles()
augroup END
