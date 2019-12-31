function ActionNotDefined()
    echo 'action not implemented'
endfunction

let ccommmondict = { 'find_this_text_string':      {'id' : '4', 'query' : 'Text:',                'key' : 't'},
                   \ 'egrep':                      {'id' : '6', 'query' : 'Egrep:',               'key' : 'e'},
                   \  'find_this_file':            {'id' : '7', 'query' : 'File:',                'key' : 'f'}}

let csdict = { 'find_symbol':                {'id' : '0', 'query' : 'C symbol:',            'key' : 's'},
             \ 'find_definition':            {'id' : '1', 'query' : 'Definition:',          'key' : 'g'},
             \ 'functions_called_by':        {'id' : '2', 'query' : 'Functions called by:', 'key' : 'd'},
             \ 'where_used':                 {'id' : '3', 'query' : 'Functions calling:',   'key' : 'c'},
             \ 'find_files_including':       {'id' : '8', 'query' : 'Files #including:',    'key' : 'i'},
             \ 'where_this_symbol_is_assigned': {'id' : '9', 'query' : 'Assignments to:',      'key' : 'a'}}

let pydict = { 'find_symbol':                {'key' : 's', 'f' : "jedi#goto"},
             \ 'find_definition':            {'key' : 'g', 'f' : "jedi#goto"},
             \ 'functions_called_by':        {'key' : 'd', 'f' : "ActionNotDefined"},
             \ 'where_used':                 {'key' : 'c', 'f' : "jedi#usages"},
             \ 'find_files_including':       {'key' : 'i', 'f' : "ActionNotDefined"},
             \ 'where_this_symbol_is_assigned': {'key' : 'a', 'f' : "jedi#goto_assignments"}}

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

function! PyscopeQuery(option, func)
    call a:func()
endfunction

function! GscopeFindFunc(q, s)
    exe('GscopeFind ' . a:q . ' ' . a:s)
endfunction

for action in items(ccommmondict)
    exe('let ' . action[0] . ' = "' . action[1].id . '"')
    exe('nnoremap <leader>g' . action[1].key . ' :call GscopeFindFunc(' . action[0] . ', expand("<cword>"))<cr>')
    exe('nnoremap <silent> <Leader>c' . action[1].key . '  :call Cscope(' .  action[0] . ', expand("<cword>"))<CR>')
    exe('nnoremap <silent> <Leader><Leader>f' . action[1].key . ' :call CscopeQuery(csdict.' . action[0] . ')<CR>')
    exe('nnoremap <silent> <Leader><Leader>c' . action[1].key . ' :call CscopeQuery(csdict.' . action[0] . ', 1)<CR>')
endfor


for action in items(csdict)
    exe('let ' . action[0] . ' = "' . action[1].id . '"')
    let cAction = action[1]
    for ft in ['c', 'cpp', 'javascript', 'make', 'vim']
        exe('autocmd FileType ' . ft . ' noremap <buffer> <leader>g' . cAction.key . ' :call GscopeFindFunc(' . action[0] . ', expand("<cword>"))<cr>')
        exe('autocmd FileType ' . ft . ' nnoremap <buffer> <silent> <Leader>c' . cAction.key . '  :call Cscope(' .  action[0] . ', expand("<cword>"))<CR>')
        exe('autocmd FileType ' . ft . ' nnoremap <buffer> <silent> <Leader><Leader>f' . cAction.key . ' :call CscopeQuery(csdict.' . action[0] . ')<CR>')
        exe('autocmd FileType ' . ft . ' nnoremap <buffer> <silent> <Leader><Leader>c' . cAction.key . ' :call CscopeQuery(csdict.' . action[0] . ', 1)<CR>')
    endfor
endfor

for action in items(pydict)
    let pyname = action[0] . '_py'
    exe('let ' . pyname . ' = "_"')
    let cAction = action[1]
    for ft in ['python']
        exe('autocmd FileType ' . ft . ' nnoremap <buffer> <silent> <leader>g' . cAction.key . ' :call PyscopeQuery(' . pyname . ', function("' . cAction.f . '"))<cr>')
    endfor
endfor
