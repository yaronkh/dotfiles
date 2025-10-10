let g:sp_home = expand('<sile>:p:h') . '/../../'
function! GetSourceFile(file)
    return g:sp_home . a:file
endfunction

let g:update_clangd_fn = stdpath('config') . '/clangd_ver_ok'

augroup ymason
    au!
    "autocmd VimEnter * source ~/dotfiles/nvim/src/telescope.lua
    autocmd VimEnter * source ~/dotfiles/nvim/lua/post_init.lua
    autocmd VimEnter * :TSEnable cpp<CR>
augroup End


source ~/dotfiles/nvim/src/plugs.lua
source ~/dotfiles/nvidia/nvidia.vim
source ~/dotfiles/nvim/lua/init.lua


" Generation Parameters
"let g:ctagsOptions = '--languages=C,C++,Vim,Python,Make,Sh,JavaScript,java --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --tag-relative'
let g:ctagsOptions = '-R --exclude=build --languages=C,C++,Vim,Python,Make,Sh,JavaScript,java --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --tag-relative'
let g:ctagsEverythingOptions = '--c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --tag-relative'
"hi CursorLineNr cterm=NONE ctermbg=00 ctermfg=0 gui=NONE guibg=#ffffff guifg=#000000
"set cursorline
" Install

function! GetBufferDirectory()
    let l:path = expand("%:p:h")
    if l:path == ""
        return $PWD
    endif
    return l:path
endfunction

function! GetProjectRoot()
    let l:pr = getcwd()
    return l:pr
    "return ProjectRootGuess(getcwd())
endfunction

let g:projects = {}

function! UpdateProjectMap()
    try
        let l:pr = GetProjectRoot()
    catch /.*/
        return
    endtry
    if l:pr == ""
        return
    endif

    if !has_key(g:projects, l:pr)
        let g:projects[l:pr] = 0
    endif

    let g:projects[l:pr] = g:projects[l:pr] + 1
endfunction

function! UnrefProject()
    let l:pat = shellescape(expand("<afile>:h"))
    if l:pat == "" || isdirectory(l:pat) == 0
        return
    endif
    echom "path:" . l:pat
    let l:pr =  ProjectRootGuess(l:pat)

    echom l:pr
    if l:pr == ""
        return
    endif

    if has_key(g:projects, l:pr)
        let g:projects[l:pr] = g:projects[l:pr] - 1
        if g:projects[l:pr] == 0
            unlet g:projects[l:pr]
        endif
    endif
endfunction

" Codesearch
nnoremap <leader>zx "tyiw:exe "CSearch " . @t . ""<CR>

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
:nnoremap <leader>sv :source $MYVIMRC<cr>

"yet another diff

" VimClang
let g:clang_c_options = '-std=c11'
let g:clang_cpp_options = '-std=c++17 -stdlib=libc++'

" Trinity
"nnoremap <C-L> :TrinityToggleNERDTree<CR>:TrinityToggleTagList<CR>
nnoremap <leader>zs :TrinityToggleSourceExplorer<CR>
nnoremap <C-w>e :TrinityUpdateWindow<CR>

" NERDTree and TagBar
let g:NERDTreeWinSize = 23
let g:NERDTreeAutoCenter = 0
let g:tagbar_width=23

function! ToggleSideHelps()
        "call NERDTreeCWD()
        execute "NERDTreeFind"
        execute "wincmd w"
        call tagbar#ToggleWindow()
        "TagbarToggle
endfunction
nnoremap <C-L> :call ToggleSideHelps()<CR>

let g:peekaboo_delay = 10

" smart expand
let g:expand_region_text_objects = get(g:, 'expand_region_text_objects', {
          \ 'iw'  :0,
          \ 'iW'  :0,
          \ 'a"'  :0,
          \ 'i''' :0,
          \ 'i]'  :2,
          \ 'a>'  :2,
          \ 'i}'  :2,
          \ 'i)'  :2,
          \ 'a)'  :2,
          \ 'ib'  :1,
          \ 'iB'  :1,
          \ 'il'  :0,
          \ 'at'  :5,
          \ 'ip'  :0,
          \ 'ie'  :0,
          \})


" Ctrlp
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ale_floating_preview = 1
let g:ale_hover_to_preview = 1

let g:ale_c_clangtidy_extra_options = '--config-file=' . expand('~/dotfiles/nvidia/clang-tidy')
let g:ale_linters = {  'c': ["clangtidy"], 'python': [], 'lua' : []}

exe "set tags+=" . GetSourceFile("nvim/tags/cpp")
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
"" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
"set completeopt=menuone,menu,longest

" " generate datebases in my cache directory, prevent gtags files polluting my project
let g:gutentags_cache_dir = expand('~/.cache/tags')
" disable gutentags, we don't need tags anymore, only some functions
let g:gutentags_enabled = 0

set rtp+=~/.fzf

function DoShowFiles()
    let l:pr = GetProjectRoot()
    let l:cscope_files = gutentags#get_cachefile(l:pr, '.cscope.files')
    let $FZF_DEFAULT_COMMAND = "if [ -s '" . l:cscope_files . "' ]; then cat '" . l:cscope_files . "'; else find '' '" . l:pr . "'; fi"
    " Empty value to disable preview window altogether
    let g:fzf_preview_window = ''
    exec ":Files " . l:pr
endfunction

function MyUpdateRemotePlugins()
    call remote#host#UpdateRemotePlugins()
endfunction

"nnoremap <C-p> :call DoShowFiles()<CR>
nnoremap <C-p> :Telescope find_files<CR>
" nnoremap <C-n> :Tags<CR>

"setting the default browser
let g:netrw_browsex_viewer="google-chrome-stable"

" Sneak
"let g:sneak#use_i"c_scs = 1
"let g:sneak#s_next = 1
let g:sneak#label = 1
map f <Plug>Sneak_s
map F <Plug>Sneak_S

" Cpp Highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1
nnoremap <M-i> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") ."> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" QuickFix
nnoremap <C-w>p :copen<CR>

" Generic
syntax on
filetype plugin indent on
filetype plugin on
nnoremap ` :noh<CR>
set expandtab
set ignorecase
set smartcase
set nocompatible
set shellslash
set autoindent
set cinoptions=g0N-s
set backspace=indent,eol,start
set ruler
set showcmd
set incsearch
set hlsearch
" set shiftwidth=4
"set tabstop=4
set cmdheight=1
"set number
set wildmode=list:longest,full
set completeopt=noinsert
set nowrap
"set colorcolumn=80
nnoremap <C-q> <C-v>
set shellslash
map <C-w>w :q<CR>
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabp<CR>
nnoremap <C-t> :tabnew<CR>
" noremap <F6> :bp<CR>
" noremap <F7> :bn<CR>
"
" turn relative line numbers on
:set relativenumber

" turn hybrid line numbers on
set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
:augroup END

noremap <F5> :set nu!<CR>:set paste!<CR>
set spelllang=en
"enable ddd  working with the mouse
" this command enables to mark visual selection with mouse
set mouse=a
set noerrorbells visualbell t_vb=
"enable spell checking
set spell

function! ShowSynGroup()
        echo synIDattr(synID(line("."), col("."), 1), "name")
endfunction

vnoremap Y y:call SendViaOSC52(getreg('"'))<CR>

let g:fzf_colors =
    \ {
      \ 'border':  ['fg', 'Search'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

hi Normal ctermbg=none

function! Panetitle()
    if @% != ""
        silent !printf '\033]2;vim: %:p\033\\'
    else
        silent !printf '\033]2;vim: empty\033\\'
    endif
endfunction

function! CopyToX11Clipboard()
    call SendViaOSC52(getreg('y'))
endfunction

function! UpdateX11Clipboard()
    call SendViaOSC52(getreg('"'))
endfunction

augroup clipboard
    autocmd!
    vnoremap <silent> <LeftRelease> y <Bar> :call UpdateX11Clipboard()<CR>
    autocmd TextYankPost * if v:event.operator ==# 'y' | call UpdateX11Clipboard() | endif
augroup End

function! RemoveWhiteSpacesFromGitHunks()
    execute(":mark '")
    execute(":GitGutter")
    let hunks = GitGutterGetHunks()
    for h in hunks
        let line = get(h, 2, -1)
        let count = get(h, 3, -1)
        if line >= 0 && count > 0
            for i in range(count)
                execute(":" . (line + i))
                execute('s/\s\+$//e')
            endfor
        endif
    endfor
    execute("''")
endfunction

function! FzfSpellSink(word)
  exe 'normal! "_ciw'.a:word
endfunction
function! FzfSpell()
  let suggestions = spellsuggest(expand("<cword>"))
  return fzf#run({'source': suggestions, 'sink': function("FzfSpellSink"), 'down': 10 })
endfunction

function! Escapeins()
    if &readonly
         call feedkeys("\<esc>")
    endif
endfunction

function! SplitVAndSwap()
    vne
    wincmd x
    wincmd l
endfunction

function! SplitAndSwap()
    new
    wincmd x
    wincmd j
endfunction

let g:do_restore_last_session = 1
let g:do_save_session = 1
if argc() > 0
    let g:do_save_session = 0
endif

function! GetLastSessionFn()
    echom gutentags#get_cachefile(getcwd(), 'LASTSESSION.vim')
    return gutentags#get_cachefile(getcwd(), 'LASTSESSION.vim')
endfunction

function! IsProj()
    return isdirectory(GetProjectRoot())
endfunction

function! SetGuttentagsEnable()
    if argc() > 0
        let g:gutentags_enabled = 0
    endif
endfunction

"AirLine configuration.
"I wanted that to do the best effort to show files names in the title.
"so, first priority is to show the full path. If that's not possible, source
"it in short wat, and if that's not possible, show only the file name without
"it's path
function! GetFileNameForBuffer()
    let l:fn = expand('%')
    let l:len = len(l:fn)
    let l:width = airline#util#winwidth() - 28
    if l:len < l:width
        return l:fn
    endif

    let l:fn = pathshorten(l:fn)
    if len(l:fn) < l:width
        return l:fn
    endif

    return expand('%:t')
endfunction

let g:airline_section_c = "%{GetFileNameForBuffer()}"
let g:airline_section_x = "%{'remote clangd:' . g:sync_started}"
let g:airline_extensions = ["ale", "searchcount"]
let g:airline#extensions#default#section_truncate_width = {
      \ 'a': 80,
      \ 'z': 80,
      \ 'warning': 80,
      \ 'error': 80,
      \ }
let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c'],
      \ ['x', 'z', 'error']
      \ ]

function! UpdateAirlineFileneames()
     " echom "resized"
endfunction
let g:airline_focuslost_inactive = 1
let g:airline_inactive_alt_sep=0
let g:airline_inactive_collapse=1

let g:airline_theme = "sierra"
let g:airline_base16_improved_contrast = 1

function! RestoreSess()
    try
        if g:do_restore_last_session > 0 && argc() == 0 && IsProj() && filereadable(GetLastSessionFn())
             exe 'source ' . GetLastSessionFn()
        endif
    catch /.*/
        let g:do_save_session = 0
    endtry
endfunction

function! SaveSess()
    " call KillDbgBuf()
    if g:do_save_session > 0 && IsProj()
        exec ":mks! " . GetLastSessionFn()
    endif
endfunction

function! EraseTralingWs()
    let save_pos = getpos(".")
    '[,']s/\s\+$//e
    call setpos('.', save_pos)
endfunction

function! InsertDate()
    r!date
endfunction

" Give indication in which mode we are at, using a cursor shape.
" | for insert
" _ for replace
" ■ for normal
augroup CursorShape
  " This is in an BufEnter autocmds because for some reason vim-gnupg reverts
  " to the original behavior.
  autocmd!

  autocmd BufEnter * call LoadCursorShapes()
augroup END

function! LoadCursorShapes()
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>"
endfunction

function! WatchVar()
    exec ":VimspectorWatch " . expand("<cword>")
endfunction

function! KillDbgBuf()
    :tabn 1
    let allt = []
    for t in range(1, tabpagenr('$'))
        :tabn
        let buffers = tabpagebuflist(t)
        for w in range(1, len(buffers))
            let l:bn = bufname(buffers[w-1])
            if l:bn =~ "vimspector"
                call add(allt, t)
                break
            endif
        endfor
    endfor
    let l:diff = 0
    for l in allt
        let l:v = l - l:diff
        exec ":tabclose " . l:v
        let l:diff = l:diff + 1
    endfor
    :bufdo call KillDbgBufE()
endfunction

function! KillDbgBufE()
    let l:bn = bufname()
    if l:bn =~ "vimspector"
        :bd
    endif
endfunction

function! SafeLaunchVimSpector()
    call vimspector#Launch()
endfunction

function! SafeCloseVimspector()
    call vimspector#Stop()
endfunction

augroup debug
     noremap ;l :call SafeLaunchVimSpector()<CR>
     noremap ;c :call vimspector#Continue()<CR>
     noremap ;b :call vimspector#ToggleBreakpoint()<CR>
     noremap ;w :call WatchVar()<CR>
     noremap ;1 :call vimspector#StepOver()<CR>
     noremap <F10> :call vimspector#StepOver()<CR>
     noremap ;i :call vimspector#StepInto()<CR>
     noremap <F11> :call vimspector#StepInto()<CR>
     noremap ;o :call vimspector#StepOut()<CR>
     noremap ;o :call vimspector#StepOut()<CR>
     noremap <S-F11> :call vimspector#StepOut()<CR>
     noremap ;t :call SafeCloseVimspector()<CR>
     noremap ;` :call KillDbgBuf()
augroup end

augroup my_tmux
    autocmd!
    autocmd bufenter * call Panetitle()
    autocmd bufenter * call Escapeins()
    autocmd BufEnter * call LoadCursorShapes()
    if v:servername == ''
        call remote_startserver(getpid())
    endif
    noremap <silent> <Leader>bx :q<CR>
    noremap <silent> <Leader>bc :cclose<CR>
    "noremap <silent> <Leader>z :tab split<CR>
    noremap <Leader>w :WinResizerStartResize<CR>
    noremap <Leader>?? :Commands<CR>SplitVAndSwap()<cr>
    noremap <Leader>h :History<CR>
    noremap <Leader>% :call SplitVAndSwap()<cr>
    noremap <Leader>" :call SplitAndSwap()<cr>
    noremap <Leader>b :bufdo bd<cr>
    noremap <Leader>r <Plug>(coc-rename)
    "remove trailing white spaces in c, c++
    "autocmd InsertLeave *.c,*.sh,*.java,*.j2,*.cpp,*.html,*.py,*.json,*.yml,*.mk,*.vim,COMMIT_EDITMSG call EraseTralingWs()
    autocmd BufWritePre,QuitPre * :call RemoveWhiteSpacesFromGitHunks()
    autocmd BufRead * : call UpdateProjectMap()
    autocmd BufDelete * : call UnrefProject()
    autocmd VimLeave * call SaveSess()
    autocmd VimLeavePre * :tabdo NERDTreeClose
    autocmd VimEnter * nested call RestoreSess()
    autocmd VimEnter * nested call SetGuttentagsEnable()
    autocmd VimResized * : call UpdateAirlineFileneames()
    vnoremap <silent><Leader>y "yy <Bar> :call CopyToX11Clipboard()<CR>
    nnoremap z= :call FzfSpell()<CR>
    inoremap <Leader>li :LinuxCodingStyle<cr>
    nnoremap <C-d> :call InsertDate()<cr>
    nnoremap <F1> :call OpenVimTmuxTerm()<CR>
    nnoremap <F2> :call OpenVimBufTmuxTerm()<CR>
    inoremap <C-d> <C-o>:call InsertDate() <CR>
    :map <Leader>tt <Plug>VimwikiToggleListItem
    "replace all occurences of the word under cursor
    :nnoremap <Leader>s :call ReplaceWordUnderCursor()<CR>
    "remap p in visual mode so the yanked  text will replace the marked text
    xnoremap p "_dP
    "map "quote this word
    :nnoremap <Leader>w" ciw""<Esc>P
    :nnoremap <Leader>T" ciW""<Esc>P
    nnoremap <C-h> :LspClangdSwitchSourceHeade <CR>

augroup end

augroup ts_config
    let g:tsuquyomi_disable_quickfix = 1
augroup end

augroup enhanced_quickfix
     " in quickfix window pressing 4 and arrow will open the link in a new
    " buffer according to the arrow direction
    autocmd! Filetype qf nnoremap <silent> <buffer> 4<Right> <C-w><Enter><C-w>L | nnoremap <silent> <buffer> 4<Left> <C-w><Enter><C-w>H | nnoremap <silent> <buffer> 4<Up> <C-w><Enter><C-w>K | nnoremap <silent> <buffer> 4<Down> <C-w><Enter><C-w>J
    autocmd Filetype qf wincmd J
augroup end


augroup brazil
    let g:brazilLastTest = ""
    let g:brazilTesting = 0
    command! Bb call BrazilBuild()
    command! Bbr call BrazilBuildRelease()
    command! Bbrec call BrazilRecuriseBuild()
    command! Btest call BrazilRunTest()
    :nnoremap <Leader>T :Btest<CR>
    autocmd USER AsyncRunStop call BrazilTestFinished()
    " :nnoremap <F1> :call RunMyPy()<CR>

    au BufRead,BufNewFile 	Config	setfiletype perl

augroup end

function! RunMyPy()
    let fname = expand('%:p')
    copen
    call BrazilSetErrFormat()
    exec ":AsyncRun mypy  " . fname
endfunction

function! BrazilSetErrFormat()
    :set errorformat=\%.%#\ File\ \"%f\"\\,\ line\ %l\\,\ %m,
    :set errorformat+=\%*\\sFile\ \"%f\"\\,\ line\ %l,
    ":set errorformat+=%f:%l%.%#
    :set errorformat+=%f:%l%m
endfunction

function! BrazilRecuriseBuild()
    copen
    call BrazilSetErrFormat()
    :AsyncRun brazil-recursive-cmd brazil-build
endfunction

function! OpenVimTmuxTerm()
    let shcmd = "tmux split-window sh -c \"cd " . GetProjectRoot() . ";exec ${SHELL:-sh}\""
    echom shcmd
    exec ":call system('" . shcmd . "')"
endfunction
function! OpenVimBufTmuxTerm()
    let d = expand('%:p:h')
    let shcmd = "tmux split-window sh -c \"cd " . d . ";exec ${SHELL:-sh}\""
    echom shcmd
    exec ":call system('" . shcmd . "')"
endfunction
function! CaptureLastIpytTb(paneid)
    copen
    exec ":AsyncRun " . GetSourceFile("vimmux/start_show_tb.sh") .  " \\" . a:paneid
endfunction

function! ReplaceWordUnderCursor()
    let w = expand("<cword>")
    let r = input('replace ' + w + ' with : ')
    :%s/w/r/g
endfunction

augroup my_vimagit
    autocmd User VimagitEnterCommit setlocal textwidth=72
    autocmd User VimagitLeaveCommit setlocal textwidth=0
    "autocmd  vimagit-VimagitLeaveCommit * :write
augroup end

augroup AutoUpdate()
    if ! exists("g:CheckUpdateStarted")
        let g:CheckUpdateStarted=1
        call timer_start(1,'CheckUpdate')
    endif
augroup end

function! CheckUpdate(timer)
    "update the file if the file has changed on disk
    silent! checktime
    "remove git signs if the file has been commited
    silent! GitGutter
    call timer_start(1000,'CheckUpdate')
   endfunction

" function! SelectBuffer()
"     let g:fzf_preview_window = 'right:50%'
"     execute ":Buffers"
" endfunction

"cool buffer switcher"
"nnoremap <silent> <Leader><Enter> :FzfPreviewBuffers<CR>
"nnoremap <silent> <Leader><Enter> :call SelectBuffer()<CR>
nnoremap <silent> <C-g>s :FzfPreviewGitStatus<CR>

" Jump to tab: <Leader>t
function TabName(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    return fnamemodify(bufname(buflist[winnr - 1]), ':t')
endfunction

function! s:jumpToTab(line)
    let pair = split(a:line, ' ')
    let cmd = pair[0].'gt'
    execute 'normal' cmd
endfunction

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
endfunction

let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

let g:fzf_action = { 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

nnoremap <silent> <Leader>t :call fzf#run({
            \   'source':  reverse(map(range(1, tabpagenr('$')),
            \ 'v:val." "." ".TabName(v:val)')),
            \   'sink':    function('<sid>jumpToTab'),
            \   'down':    tabpagenr('$') + 2
            \ })<CR>
"})
"
"Jump to tag in the current buffer
function! Align_lists(lists)
    let maxes = {}
    for list in a:lists
        let i = 0
        while i < len(list)
            let maxes[i] = max([get(maxes, i, 0), len(list[i])])
            let i += 1
        endwhile
    endfor
    for list in a:lists
        call map(list, "printf('%-'.maxes[v:key].'s', v:val)")
    endfor
    return a:lists
endfunction

function! Btags_source()
    let lines = map(split(system(printf(
                \ 'ctags -f - --sort=no --excmd=number %s',
                \ expand('%:S'))), "\n"), 'split(v:val, "\t")')
    if v:shell_error
        throw 'failed to extract tags'
    endif
    return map(Align_lists(lines), 'join(v:val, "\t")')
endfunction

function! Btags_sink(line)
    execute split(a:line, "\t")[2]
endfunction

"function! Btags()
"    try
"        call fzf#run({
"                    \ 'source':  Btags_source(),
"                    \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
"                    \ 'down':    '40%',
"                    \ 'sink':    function('Btags_sink')})
"    catch
"        echohl WarningMsg
"        echom v:exception
"        echohl None
"    endtry
"endfunction

function! Btags()
    try
        call fzf#run({
                    \ 'source':  Btags_source(),
                    \ 'down':    '40%',
                    \ 'sink':    function('Btags_sink')})
    catch
        echohl WarningMsg
        echom v:exception
        echohl None
    endtry
endfunction

command! BTags call Btags()
nnoremap <silent> <F3> :call Btags()<CR>

"function! s:get_visual_selection()
"    " Why is this not a built-in Vim script function?!
"    let [line_start, column_start] = getpos("'<")[1:2]
"    let [line_end, column_end] = getpos("'>")[1:2]
"    let lines = getline(line_start, line_end)
"    if len(lines) == 0
"        return ''
"    endif
"    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
"    let lines[0] = lines[0][column_start - 1:]
"    return join(lines, "\n")
"endfunction

function! Mgrep(t)
    copen
    exec ":AsyncRun find . -name .repo -prune -o -name .git -prune -o -path ./out -prune -o -regextype posix-egrep -iregex '(.*\/Makefile|.*\/Makefile\..*|.*\.make|.*\.mak|.*\.mk)' -type f -exec grep --color -n " . shellescape(a:t) . ' {} +'
endfunction

command! -nargs=* Mg call Mgrep(<q-args>)

"function! s:get_visual_selection()
"    let [line_start, column_start] = getpos("'<")[1:2]
"    let [line_end, column_end] = getpos("'>")[1:2]
"    let lines = getline(line_start, line_end)
"    if len(lines) == 0
"        return ''
"    endif
"    let lines[-1] = lines[-1][: column_end - 2]
"    let lines[0] = lines[0][column_start - 1:]
"    return join(lines, "\n")
"endfunction

"To specify a preferred indent level when no detection is possible:
let g:detectindent_preferred_indent = 4
let g:detectindent_max_lines_to_analyse = 10
let g:detectindent_preferred_when_mixed = 3
