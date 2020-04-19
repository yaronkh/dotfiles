" Plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"this is the first diff"

call plug#begin()
"Plug 'ctrlpvim/ctrlp.vim'
 "Plug 'justmao945/vim-clang'
"Plug 'chazy/cscope_maps'
Plug 'wesleyche/SrcExpl'
Plug 'vim-scripts/taglist.vim'
Plug 'scrooloose/nerdtree'
Plug 'wesleyche/Trinity'
Plug 'vim-scripts/OmniCppComplete' "C/C++ omni-completion with ctags database
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
"Plug 'rdolgushin/snipMate-acp'
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
"Plug 'xolox/vim-easytags'
Plug 'simeji/winresizer'
Plug 'vim-scripts/DetectIndent'
Plug 'airblade/vim-gitgutter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'me-vlad/spellfiles.vim'
"Plug 'sakhnik/nvim-gdbm'
Plug 'cpiger/NeoDebug'
Plug 'kshenoy/vim-signature'
Plug 'vivien/vim-linux-coding-style'
"Plug 'scrooloose/nerdcommenter'
"Plug 'ycm-core/YouCompleteMe'
Plug 'davidhalter/jedi-vim'
Plug 'gotcha/vimpdb'
Plug 'tpope/vim-fugitive'
Plug 'dense-analysis/ale'
Plug 'yuki-ycino/fzf-preview.vim'
Plug 'jreybert/vimagit'
call plug#end()

" Generation Parameters
let g:ctagsFilePatterns = '\.c$|\.cc$|\.cpp$|\.yml|\.cxx$|\.h$|\.hh$|\.hpp$|\.py$|\.mk$|\.bash$|\.sh$|\.vim$|make|Make|\.json$|\.j2|.rc$'
let g:ctagsOptions = '--languages=C,C++,Vim,Python,Make,Sh,JavaScript --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --tag-relative'
let g:ctagsEverythingOptions = '--c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --tag-relative'
highlight CursorLineNr cterm=NONE ctermbg=15 ctermfg=8 gui=NONE guibg=#ffffff guifg=#d70000
set cursorline
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
    exec ":AsyncRun ctags -R " . g:ctagsOptions . " && echo '" . g:ctagsOptions . "' > .gutctags && sed -i 's/ /\\n/g' .gutctags && gtags && ag -l -i -g '" . g:ctagsFilePatterns . "' > cscope.files && cscope -bq"
endfunction

" Generate All
function! ZGenerateEverything()
    copen
    exec ":AsyncRun ctags -R " . g:ctagsEverythingOptions . " && echo '" . g:ctagsEverythingOptions . "' > .gutctags && gtags && sed -i 's/ /\\n/g' .gutctags && ag -l > cscope.files && cscope -bq index"
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
nnoremap  <leader>zG :call ZGenerateEverything()<CR>

" Generate Tags and Cscope Files Mapping
nnoremap <leader>zt :call ZGenTagsAndCsFiles()<CR>

" Codesearch
nnoremap <leader>zx "tyiw:exe "CSearch " . @t . ""<CR>

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
:nnoremap <leader>sv :source $MYVIMRC<cr>

"yet another diff

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

"python linting
" Check Python files with flake8 and pylint.
"let b:ale_linters = ['flake8', 'pylint']
let b:ale_linters = ['pylint']
" Fix Python files with autopep8 and yapf.
let b:ale_fixers = ['autopep8', 'yapf']
" Disable warnings about trailing whitespace for Python files.
let b:ale_warn_about_trailing_whitespace = 0
let g:ale_python_pylint_options = '--rcfile ~/dotfiles/pylint.rc'


" Omni
"au BufNewFile,BufRead,BufEnter *.cpp,*.hpp,*.c,*.h,*.cxx,*.cc,*.hh set omnifunc=omni#cpp#complete#Main
"let g:acp_behaviorSnipmateLength = 1
set tags+=~/dotfiles/nvim/tags/cpp
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
set completeopt=menuone,menu,longest,preview

" GutenTags
let g:gutentags_modules = ['ctags']
" enable gtags module
let g:gutentags_modules = ['ctags', 'gtags_cscope']

" config project root markers.
"let g:gutentags_project_root = ['.root']

" generate datebases in my cache directory, prevent gtags files polluting my p                                                                                                             roject
let g:gutentags_cache_dir = expand('~/.cache/tags')

" forbid gutentags adding gtags databases
let g:gutentags_auto_add_gtags_cscope = 0

let g:gutentags_plus_nomap = 1
set statusline+=%{gutentags#statusline()}
let g:gutentags_define_advanced_commands = 1
" Fzf
let $FZF_DEFAULT_COMMAND = "if [ -s cscope.files ]; then cat cscope.files; else ag -l; fi"
set rtp+=~/.fzf
nnoremap <C-p> :call ZSwitchToRoot()<CR>:Files<CR>
nnoremap <C-n> :call ZSwitchToRoot()<CR>:Tags<CR>

"setting the default browser
let g:netrw_browsex_viewer="google-chrome-stable"

" Sneak
"let g:sneak#use_i"c_scs = 1
"let g:sneak#s_next = 1
let g:sneak#label = 1
map f <Plug>Sneak_s
map F <Plug>Sneak_S
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
filetype plugin on
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
"set shiftwidth=4
"set tabstop=4
set cmdheight=1
"set number
set wildmode=list:longest,full
set completeopt=longest,menuone
set nowrap
"set colorcolumn=80
nnoremap <C-q> <C-v>
set shellslash
map <C-w>w :q<CR>
autocmd filetype make setlocal noexpandtab autoindent
autocmd filetype sh setlocal expandtab
noremap <F1> <C-w><C-p>
noremap <F2> <C-w><C-w>
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabp<CR>
nnoremap <C-t> :tabnew<CR>
noremap <F6> :bp<CR>
noremap <F7> :bn<CR>
noremap <F5> :set nu!<CR>:set paste!<CR>
set spelllang=en
"enable ddd  working with the mouse
set mouse=a
set noerrorbells visualbell t_vb=
"enable spell checking
set spell

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

function! CopyToX11Clipboard()
    call system('xclip -i -sel clipboard', @y)
    call system('xclip -i -sel primary', @y)
    call system('xclip -i -sel secondary', @y)
endfunction

function! PasteFromX11()
    let @y = system('xsel', '-o')
    normal! "ypl
endfunction

function! UpdateX11Clipboard()
    call system('xclip -i -sel clipboard', @")
    call system('xclip -i -sel primary', @")
    call system('xclip -i -sel secondary', @")
endfunction

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

function! RestoreSess()
  if argc() > 0
      let g:do_save_session = 0
  endif

  if g:do_restore_last_session > 0 && argc() == 0 && filereadable('GPATH') && filereadable('LASTSESSION.vim')
    source LASTSESSION.vim
  endif
endfunction

function! SaveSess()
    if g:do_save_session > 0 && filereadable('GPATH')
        :mks! LASTSESSION.vim
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

augroup my_tmux
    autocmd!
    autocmd bufenter * call Panetitle()
    autocmd bufenter * call Escapeins()
    if v:servername == ""
        call remote_startserver(getpid())
    endif
    noremap <silent> <Leader>bx :q<CR>
    noremap <silent> <Leader>bc :cclose<CR>
    noremap <silent> <Leader>z :tab split<CR>
    noremap <Leader>w :WinResizerStartResize<CR>
    noremap <Leader>? :Maps<CR>
    noremap <Leader>?? :Commands<CR>SplitVAndSwap()<cr>
    noremap <Leader>h :History<CR>
    noremap <Leader>% :call SplitVAndSwap()<cr>
    noremap <Leader>" :call SplitAndSwap()<cr>
    noremap <Leader>b :bufdo bd<cr>
    "remove trailing white spaces in c, c++
    autocmd InsertLeave *.c,*.sh,*.j2,*.cpp,*.html,*.py,*.json,*.yml,*.mk,*.vim,COMMIT_EDITMSG call EraseTralingWs()
    autocmd BufWritePre,BufUnload,QuitPre * :call RemoveWhiteSpacesFromGitHunks()
    autocmd VimLeave * call SaveSess()
    autocmd VimEnter * nested call RestoreSess()
    "autocmd BufWriteCmd * :call RemoveWhiteSpacesFromGitHunks()
    "interface to X11 clipboard with the help of xclip
    vnoremap <silent><Leader>y "yy <Bar> :call CopyToX11Clipboard()<CR>
    nnoremap <silent> <leader>p :call PasteFromX11() <CR>
    vnoremap <silent> <LeftRelease> y <Bar> :call UpdateX11Clipboard()<CR>
    noremap <silent> <RightMouse> :Maps<cr>
    "execute("command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis")
    nnoremap z= :call FzfSpell()<CR>
    inoremap <Leader>li :LinuxCodingStyle<cr>
    let g:linuxsty_patterns = [ "/kernel/", "/linux/"]
    nnoremap <C-d> :call InsertDate()<cr>
    inoremap <C-d> <C-o>:call InsertDate() <CR>
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

"cool buffer switcher"
"nnoremap <silent> <Leader><Enter> :FzfPreviewBuffers<CR>
nnoremap <silent> <Leader><Enter> :call fzf#run({
            \   'source':  reverse(<sid>buflist()),
            \   'sink':    function('<sid>bufopen'),
            \   'options': '+m',
            \   'down':    len(<sid>buflist()) + 2
            \  })<CR>

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

function! Mgrep(t)
    copen
    exec ":AsyncRun find . -name .repo -prune -o -name .git -prune -o -path ./out -prune -o -regextype posix-egrep -iregex '(.*\/Makefile|.*\/Makefile\..*|.*\.make|.*\.mak|.*\.mk)' -type f -exec grep --color -n " . shellescape(a:t) . ' {} +'
endfunction

command! -nargs=* Mg call Mgrep(<q-args>)
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
            \ })

"detectIndent stuff
"==================
autocmd BufReadPost * :DetectIndent

"Options:

"To prefer 'expandtab' to 'noexpandtab' when no detection is possible:
"let g:detectindent_preferred_expandtab = 1

"To specify a preferred indent level when no detection is possible:
let g:detectindent_preferred_indent = 4
let g:detectindent_max_lines_to_analyse = 10
let g:detectindent_preferred_when_mixed = 3

"google compilation"
function! MakeRoot()
    copen
    exec ":AsyncRun bash -ci \"cd $ANDROID_BUILD_TOP; m -j 16\""
endfunction

function! MM()
    copen
    exec "AsyncRun bash -ci \"cd $VIM_FILEPATH; mm -j\""
endfunction

function! MakeBootImage()
    copen
    exec "AsyncRun bash -ci \"croot; make bootimage -j\""
endfunction

augroup my_tmux
    nnoremap <Leader>m :call MakeRoot()<CR>
    nnoremap <Leader>mm :call MM()<CR>
    nnoremap <Leader>mb :call MakeBootImage()<CR>
augroup end
