let csdict = { 'find_c_symbol':                 {'id' : '0', 'query' : 'C symbol:',            'key' : 's'},
             \ 'find_definition':               {'id' : '1', 'query' : 'Definition:',          'key' : 'g'},
             \ 'functions_called_by':           {'id' : '2', 'query' : 'Functions called by:', 'key' : 'd'},
             \ 'where_used':                    {'id' : '3', 'query' : 'Functions calling:',   'key' : 'c'},
             \ 'find_this_text_string':         {'id' : '4', 'query' : 'Text:',                'key' : 't'},
             \ 'egrep':                         {'id' : '6', 'query' : 'Egrep:',               'key' : 'e'},
             \ 'find_this_file':                {'id' : '7', 'query' : 'File:',                'key' : 'f'},
             \ 'find_files_including':          {'id' : '8', 'query' : 'Files #including:',    'key' : 'i'},
             \ 'where_this_symbol_is_assigned': {'id' : '9', 'query' : 'Assignments to:',      'key' : 'a'}}

function! CscopeQuery(option, ...)
    call inputsave()
    let query = input(a:option.query)
    call inputrestore()
    let ignorecase = get(a:, 1, 0)
    if ignorecase
        call Cscope(a:option.id, a:option.query, 1)
    else
        call Cscope(a:option.id, a:option.query)
    endif
endfunction

function! GscopeFindFunc(q, s)
    exe('GscopeFind ' . a:q . ' ' . a:s)
endfunction

for action in items(csdict)
    exe('let ' . action[0] . ' = "' . action[1].id . '"')
    exe('nnoremap <leader>g' . action[1].key . ' :call GscopeFindFunc(' . action[0] . ', expand("<cword>"))<cr>')
    exe('nnoremap <silent> <Leader>c' . action[1].key . '  :call Cscope(' .  action[0] . ', expand("<cword>"))<CR>')
    exe('nnoremap <silent> <Leader><Leader>f' . action[1].key . ' :call CscopeQuery(csdict.' . action[0] . ')<CR>')
    exe('nnoremap <silent> <Leader><Leader>c' . action[1].key . ' :call CscopeQuery(csdict.' . action[0] . ', 1)<CR>')
endfor
