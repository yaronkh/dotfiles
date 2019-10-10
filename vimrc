" Plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
"Plug 'ctrlpvim/ctrlp.vim'
"Plug 'justmao945/vim-clang'
"Plug 'chazy/cscope_maps'
Plug 'wesleyche/SrcExpl'
Plug 'vim-scripts/taglist.vim'
Plug 'scrooloose/nerdtree'
Plug 'wesleyche/Trinity'
Plug 'vim-scripts/OmniCppComplete'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'rdolgushin/snipMate-acp'
Plug 'vim-scripts/AutoComplPop'
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/a.vim'
Plug 'ervandew/supertab'
Plug 'vim-airline/vim-airline'
Plug 'skywind3000/asyncrun.vim'
Plug 'justinmk/vim-sneak'
Plug 'brandonbloom/csearch.vim'
"Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'
Plug 'terryma/vim-multiple-cursors'
Plug 'morhetz/gruvbox'
Plug 'vim-scripts/TagHighlight'
Plug 'erig0/cscope_dynamic'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags'
Plug 'simeji/winresizer'
Plug 'vim-scripts/DetectIndent'
call plug#end()

" Generation Parameters
let g:ctagsFilePatterns = '\.c$|\.cc$|\.cpp$|\.cxx$|\.h$|\.hh$|\.hpp$'
let g:ctagsOptions = '--languages=C,C++ --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --tag-relative'
let g:ctagsEverythingOptions = '--c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --tag-relative'

" Install
function! ZInstall()
    copen
    exec ":AsyncRun sudo apt install silversearcher-ag exuberant-ctags cscope global codesearch -y
                \ & sed -i 's/ autochdir/ noautochdir/' ~/.vim/plugged/SrcExpl/plugin/srcexpl.vim
                \ & sed -i 's/silent execute \"perl/silent execute \"!perl/' ~/.vim/plugged/cscope_dynamic/plugin/cscope_dynamic.vim 
                \ & sed -i 's@ . redraw!@\ . \" > /dev/null\"@' ~/.vim/plugged/cscope_dynamic/plugin/cscope_dynamic.vim
                \ & sed -i \"s/'String',[ \\t]*s\\:green/'String', \\['\\#d78787', 174\\]/\" ~/.vim/plugged/gruvbox/colors/gruvbox.vim"
endfunction

" Generate All
function! ZGenerateAll()
    copen
    exec ":AsyncRun ctags -R " . g:ctagsOptions . " && echo '" . g:ctagsOptions . "' > .gutctags && sed -i 's/ /\\n/g' .gutctags && ag -l -g '" . g:ctagsFilePatterns . "' > cscope.files && cscope -bq && cindex . && gtags"
endfunction

" Generate All
function! ZGenerateEverything()
    copen
    exec ":AsyncRun ctags -R " . g:ctagsEverythingOptions . " && echo '" . g:ctagsEverythingOptions . "' > .gutctags && sed -i 's/ /\\n/g' .gutctags && ag -l > cscope.files && cscope -bq && cindex . && gtags"
endfunction

" Write tags options.
function! ZWriteTagsOptions()
    copen
    exec ":AsyncRun echo " . g:ctagsOptions . " > .gutctags && sed -i 's/ /\\n/g' .gutctags"
endfunction

" Generate Tags
function! ZGenTags()
    copen
    exec ":AsyncRun ctags -R " . g:ctagsOptions
endfunction

" Generate Cscope Files
function! ZGenCsFiles()
    copen
    exec ":AsyncRun ag -l -g '" . g:ctagsFilePatterns . "' > cscope.files"
endfunction

" Generate Tags and Cscope Files
function! ZGenTagsAndCsFiles()
    copen
    exec ":AsyncRun ag -l -g '" . g:ctagsFilePatterns . "' > cscope.files && ctags -R " . g:ctagsOptions
endfunction

" Install Mapping
nnoremap <leader>zi :call ZInstall()<CR>

" Generate All Mapping
nnoremap <leader>zg :call ZGenerateAll()<CR>
nnoremap <leader>zG :call ZGenerateEverything()<CR>

" Generate Tags and Cscope Files Mapping
nnoremap <leader>zt :call ZGenTagsAndCsFiles()<CR>

" Codesearch
nnoremap <leader>zx "tyiw:exe "CSearch " . @t . ""<CR>

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
:nnoremap <leader>sv :source $MYVIMRC<cr>

" VimClang
let g:clang_c_options = '-std=c11'
let g:clang_cpp_options = '-std=c++17 -stdlib=libc++'

let g:vimroot=$PWD
function! ZSwitchToRoot()
    execute "cd " . g:vimroot 
endfunction
nnoremap <leader>zr :call ZSwitchToRoot()<CR>

" Trinity
"nnoremap <C-L> :TrinityToggleNERDTree<CR>:TrinityToggleTagList<CR>
nnoremap <leader>zs :TrinityToggleSourceExplorer<CR>
nnoremap <C-w>e :TrinityUpdateWindow<CR>

" NERDTree and TagBar
let g:NERDTreeWinSize = 23
let g:NERDTreeAutoCenter = 0
let g:tagbar_width=23
nnoremap <C-L> :NERDTreeToggle<CR>:wincmd w<CR>:TagbarToggle<CR>

" Ctrlp
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

" Omni
"au BufNewFile,BufRead,BufEnter *.cpp,*.hpp,*.c,*.h,*.cxx,*.cc,*.hh set omnifunc=omni#cpp#complete#Main
let g:acp_behaviorSnipmateLength = 1

" GutenTags
let g:gutentags_modules = ['ctags', 'gtags_cscope']
let g:gutentags_plus_nomap = 1
" Fzf
let $FZF_DEFAULT_COMMAND = "if [ -f cscope.files ]; then cat cscope.files; else ag -l; fi"
set rtp+=~/.fzf
nnoremap <C-p> :call ZSwitchToRoot()<CR>:Files<CR>
nnoremap <C-n> :call ZSwitchToRoot()<CR>:Tags<CR>

" Sneak
let g:sneak#use_ic_scs = 1
let g:sneak#s_next = 1

" Cscope
let g:cscopedb_big_file = 'cscope.out'
let g:cscopedb_small_file = 'cscope_small.out'
let g:cscopedb_auto_files = 0

" Multi Cursor
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_start_word_key      = '<C-k>'
"let g:multi_cursor_select_all_word_key = '<A-k>'
let g:multi_cursor_start_key           = 'g<C-k>'
"let g:multi_cursor_select_all_key      = 'g<A-k>'
let g:multi_cursor_next_key            = '<C-k>'
let g:multi_cursor_prev_key            = '<C-e>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

" Cpp Highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1

" QuickFix
nnoremap <C-w>p :copen<CR>

" Generic
syntax on
filetype plugin indent on
nnoremap ` :noh<CR>
set expandtab
set ignorecase
set smartcase
set nocompatible
set shellslash
set autoindent
autocmd filetype cpp setlocal cindent
autocmd filetype c setlocal cindent
set cinoptions=g0N-s
set backspace=indent,eol,start
set ruler
set showcmd
set incsearch
set hlsearch
color desert
set shiftwidth=4
set tabstop=4
set cmdheight=1
"set number
set wildmode=list:longest,full
set completeopt=longest,menuone
set nowrap
nnoremap <C-q> <C-v>
set shellslash
map <C-w>w :q<CR>
autocmd filetype make setlocal noexpandtab autoindent
noremap <F1> <C-w><C-p>
noremap <F2> <C-w><C-w>
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabp<CR>
nnoremap <C-t> :tabnew<CR>
noremap <F6> :bp<CR>
noremap <F7> :bn<CR>
noremap <F5> :set nu!<CR>:set paste!<CR>
set noerrorbells visualbell t_vb=

" Extensions
function! Cscope(option, query, ...)
    let realoption = a:option

    let color = '{ x = $1; $1 = ""; z = $3; $3 = ""; printf "\033[36m%s\033[0m:\033[36m%s\033[0m\011\033[37m%s\033[0m\n", x,z,$0; }'
    let opts = {
                \ 'source':  "cscope -dL" . realoption . " " . a:query . " | awk '" . color . "' && cscope -f cscope_small.out -dL" . realoption . " " . a:query . " | awk '" . color . "'",
                \ 'options': ['--ansi', '--prompt', '> ',
                \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
                \             '--color', 'fg:188,fg+:222,bg+:#3a3a3a,hl+:104'],
                \ 'down': '40%'
                \ }

    function! opts.sink(lines) 
        let data = split(a:lines)
        let file = split(data[0], ":")
        execute 'e ' . '+' . file[1] . ' ' . file[0]
    endfunction
    call fzf#run(opts)
endfunction

function! CscopeQuery(option, ...)
    call inputsave()
    if a:option == '9'
        let query = input('Assignments to: ')
    elseif a:option == '3'
        let query = input('Functions calling: ')
    elseif a:option == '2'
        let query = input('Functions called by: ')
    elseif a:option == '6'
        let query = input('Egrep: ')
    elseif a:option == '7'
        let query = input('File: ')
    elseif a:option == '1'
        let query = input('Definition: ')
    elseif a:option == '8'
        let query = input('Files #including: ')
    elseif a:option == '0'
        let query = input('C Symbol: ')
    elseif a:option == '4'
        let query = input('Text: ')
    else
        echo "Invalid option!"
        return
    endif
    call inputrestore()
    if query != ""
        let ignorecase = get(a:, 1, 0)
        if ignorecase
            call Cscope(a:option, query, 1)
        else
            call Cscope(a:option, query)
        endif
    else
        echom "Cancelled Search!"
    endif
endfunction

let csdict = { 'find_c_symbol': '0',
             \ 'find_definition': '1',
             \ 'functions_called_by': '2',
             \ 'where_used': '3',
             \ 'find_this_text_string': '4',
             \ 'egrep': '6',
             \ 'find_this_file': '7',
             \ 'find_files_including': '8',
             \ 'where_this_symbol_is_assigned': '9'}

noremap <silent> <leader>gs :GscopeFind csdict.find_c_symbol <C-R><C-W><cr>
noremap <silent> <leader>gg :GscopeFind csdict.find_definition <C-R><C-W><cr>
noremap <silent> <leader>gc :GscopeFind csdict.where_used <C-R><C-W><cr>
noremap <silent> <leader>gt :GscopeFind csdict.find_this_text_string <C-R><C-W><cr>
noremap <silent> <leader>ge :GscopeFind csdict.egrep <C-R><C-W><cr>
noremap <silent> <leader>gf :GscopeFind csdict.find_this_file <C-R>=expand("<cfile>")<cr><cr>
noremap <silent> <leader>gi :GscopeFind csdict.find_files_including <C-R>=expand("<cfile>")<cr><cr>
noremap <silent> <leader>gd :GscopeFind csdict.functions_called_by <C-R><C-W><cr>
noremap <silent> <leader>ga :GscopeFind csdict.where_this_symbol_is_assigned <C-R><C-W><cr>

nnoremap <silent> <Leader>ca :call Cscope(csdict.where_this_symbol_is_assigned, expand('<cword>'))<CR> 
nnoremap <silent> <Leader>cc :call Cscope(csdict.where_used                   , expand('<cword>'))<CR>
nnoremap <silent> <Leader>cd :call Cscope(csdict.functions_called_by          , expand('<cword>'))<CR>
nnoremap <silent> <Leader>ce :call Cscope(csdict.egrep                        , expand('<cword>'))<CR>
nnoremap <silent> <Leader>cf :call Cscope(csdict.find_this_file               , expand('<cword>'))<CR>
nnoremap <silent> <Leader>cg :call Cscope(csdict.find_definition              , expand('<cword>'))<CR>
nnoremap <silent> <Leader>ci :call Cscope(csdict.find_files_including         , expand('<cword>'))<CR>
nnoremap <silent> <Leader>cs :call Cscope(csdict.find_c_symbol                , expand('<cword>'))<CR>
nnoremap <silent> <Leader>ct :call Cscope(csdict.find_this_text_string        , expand('<cword>'))<CR>

nnoremap <silent> <Leader><Leader>fa :call CscopeQuery(csdict.where_this_symbol_is_assigned)<CR>
nnoremap <silent> <Leader><Leader>fc :call CscopeQuery(csdict.where_used                   )<CR>
nnoremap <silent> <Leader><Leader>fd :call CscopeQuery(csdict.functions_called_by          )<CR>
nnoremap <silent> <Leader><Leader>fe :call CscopeQuery(csdict.egrep                        )<CR>
nnoremap <silent> <Leader><Leader>ff :call CscopeQuery(csdict.find_this_file               )<CR>
nnoremap <silent> <Leader><Leader>fg :call CscopeQuery(csdict.find_definition              )<CR>
nnoremap <silent> <Leader><Leader>fi :call CscopeQuery(csdict.find_files_including         )<CR>
nnoremap <silent> <Leader><Leader>fs :call CscopeQuery(csdict.find_c_symbol                )<CR>
nnoremap <silent> <Leader><Leader>ct :call CscopeQuery(csdict.find_this_text_string        )<CR>

nnoremap <silent> <Leader><Leader>ca :call CscopeQuery(csdict.where_this_symbol_is_assigned, 1)<CR>
nnoremap <silent> <Leader><Leader>cc :call CscopeQuery(csdict.where_used                   , 1)<CR>
nnoremap <silent> <Leader><Leader>cd :call CscopeQuery(csdict.functions_called_by          , 1)<CR>
nnoremap <silent> <Leader><Leader>ce :call CscopeQuery(csdict.egrep                        , 1)<CR>
nnoremap <silent> <Leader><Leader>cf :call CscopeQuery(csdict.find_this_file               , 1)<CR>
nnoremap <silent> <Leader><Leader>cg :call CscopeQuery(csdict.find_definition              , 1)<CR>
nnoremap <silent> <Leader><Leader>ci :call CscopeQuery(csdict.find_files_including         , 1)<CR>
nnoremap <silent> <Leader><Leader>cs :call CscopeQuery(csdict.find_c_symbol                , 1)<CR>
nnoremap <silent> <Leader><Leader>ct :call CscopeQuery(csdict.find_this_text_string        , 1)<CR>

" Gruvbox
set background=dark
let g:gruvbox_contrast_datk = 'medium'
color gruvbox
hi Normal ctermbg=none

function! Panetitle()
    if @% != ""
        silent !printf '\033]2;vim: %:p\033\\'
    else 
        silent !printf '\033]2;vim: empty\033\\'
    endif
endfunction

augroup my_tmux
    autocmd!
    autocmd bufenter * call Panetitle()
    if v:servername == ""
        call remote_startserver(getpid())
    endif
    noremap <silent> <Leader>bx :q<CR>
    noremap <silent> <Leader>bc :cclose<CR>
    noremap <silent> <Leader>z :tab split<CR>
    noremap <Leader>w :WinResizerStartResize<CR>
    noremap <Leader>? :Maps<CR>
    noremap <Leader>% :vsplit<CR>
    noremap <Leader>" :split<CR>
    "remove trailing white spaces in c, c++
    autocmd InsertLeave *.c,*.cpp,*.html,*.py,*.json,*.mk '[,']s/\s\+$//e | normal! `^
augroup end

function! s:buflist()
    redir => ls
    silent ls
    redir END
    return split(ls, '\n')
endfunction

function! s:bufopen(e)
    execute 'buffer' matchstr(a:e, '^[ 0-9 ]*')
endfunction

nnoremap <silent> <Leader><Enter> :call fzf#run({
            \   'source':  reverse(<sid>buflist()),
            \   'sink':    function('<sid>bufopen'),
            \   'options': '+m',
            \   'down':    len(<sid>buflist()) + 2
            \  })<CR>


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
                \ 'ctags -f - --sort=no --excmd=number --language-force=%s %s',
                \ &filetype, expand('%:S'))), "\n"), 'split(v:val, "\t")')
    if v:shell_error
        throw 'failed to extract tags'
    endif
    return map(Align_lists(lines), 'join(v:val, "\t")')
endfunction

function! Btags_sink(line)
    execute split(a:line, "\t")[2]
endfunction

function! Btags()
    try
        call fzf#run({
                    \ 'source':  Btags_source(),
                    \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
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

function! Agg(t)
    copen
    exec ":AsyncRun ag " . shellescap(a:t)
endfunction
"
"narrow results with ag
function! s:ag_to_qf(line)
    let parts = split(a:line, ':')
    return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
                \ 'text': join(parts[3:], ':')}
endfunction

function! s:ag_handler(lines)
    if len(a:lines) < 2 | return | endif

    let cmd = get({'ctrl-x': 'split',
                \ 'ctrl-v': 'vertical split',
                \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
    let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

    let first = list[0]
    execute cmd escape(first.filename, ' %#\')
    execute first.lnum
    execute 'normal!' first.col.'|zz'

    if len(list) > 1
        call setqflist(list)
        copen
        wincmd p
    endif
endfunction

command! -nargs=* Ag call fzf#run({
            \ 'source':  printf('ag --nogroup --column --color "%s"',
            \                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
            \ 'sink*':    function('<sid>ag_handler'),
            \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
            \            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
            \            '--color hl:68,hl+:110',
            \ 'down':    '50%'
            \ })"'))

"detectIndent stuff
"==================
autocmd BufReadPost * :DetectIndent

"Options:

"To prefer 'expandtab' to 'noexpandtab' when no detection is possible: 
let g:detectindent_preferred_expandtab = 1

"To specify a preferred indent level when no detection is possible:
let g:detectindent_preferred_indent = 4

"google compilation"
function! MakeRoot()
    copen
    exec ":AsyncRun bash -ci \"cd $ANDROID_BUILD_TOP; m -j 16\""
endfunction

function! MM()
    copen
    exec "AsyncRun bash -ci \"cd $VIM_FILEPATH; mm -j\""
endfunction

augroup my_tmux
    nnoremap <Leader>m :call MakeRoot()<CR>
    nnoremap <Leader>mm :call MM()<CR>
augroup end
