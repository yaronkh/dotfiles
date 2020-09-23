" Plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"this is the first diff"

call plug#begin()
" vimspector - debugger front end for debugger. In particular it is used for
" gdb and debugpy
Plug 'puremourning/vimspector'

" align text in old c-style fashin style
Plug 'junegunn/vim-easy-align'

" enable tag search in all opened buffers
Plug 'vim-scripts/taglist.vim'

" file system explorer for vim editor
Plug 'scrooloose/nerdtree'

" manages nerdtree and taglist in single system ui
" presee C-L to toggle that view
Plug 'wesleyche/Trinity'

" cpp completions with ctags database (created in gutentags and
" gutentags_plus)
Plug 'vim-scripts/OmniCppComplete'

" function libraries used by other plugins
Plug 'tomtom/tlib_vim'
"Plug 'rdolgushin/snipMate-acp'

" opens completion popup when certain characters are typed
Plug 'vim-scripts/AutoComplPop'

" manages tag files under ~/.cache/tags
Plug 'ludovicchabant/vim-gutentags'

" expands vim-gutentags so files from multiple projects
Plug 'skywind3000/gutentags_plus'

" enable fzf functions in vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Opens and navigate through alternate files
" for example, if you are on c file and want todo
" open the corresponding h files in vertical split, just run :AV
Plug 'vim-scripts/a.vim'

" fancy tabline and statusline that light according to edit mode
Plug 'vim-airline/vim-airline'

" run things asynchronous
Plug 'skywind3000/asyncrun.vim'

" Plug 'brandonbloom/csearch.vim'
"Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'

" retro style for vim`
Plug 'morhetz/gruvbox'

" highlight tags in code
Plug 'vim-scripts/TagHighlight'

" enable virtual selection of code block
" for example, enter into virtual selection mode (press v)
" than, press + for expand the selection and _ for shrink it back
Plug 'terryma/vim-expand-region'

" additional vim c++ syntax highlighting
" this includes c++11/14/17 and much more
Plug 'octol/vim-cpp-enhanced-highlight'

" basic plugin that provides many misc functionality
" for example, run functions asynchrounously, periodic call and more
Plug 'xolox/vim-misc'

" plugin for resizing window, Pres C-E and start playing
Plug 'simeji/winresizer'
"Plug 'vim-scripts/DetectIndent'
"
"A Vim plugin which shows a git diff in the sign column
Plug 'airblade/vim-gitgutter'

" This plugin causes all trailing whitespace characters to be highlighted.
Plug 'ntpeters/vim-better-whitespace'

" spelling plugin. spells comments and strings in code
" to fix words, place the cursor on a problematic word and press z=
Plug 'me-vlad/spellfiles.vim'
"Plug 'sakhnik/nvim-gdbm'

" plugin around gdb, this plugin is deprecated in favor
" of vimspector
Plug 'cpiger/NeoDebug'

" show marks and bookmarks in the sign side coloumn
Plug 'kshenoy/vim-signature'

" detect linux kernel code and mark code that
" violates linux coding style
Plug 'vivien/vim-linux-coding-style'

" code completer for python, that uses jedi library
" I've exanded that to include 'goto-definition' and
" where used
Plug 'davidhalter/jedi-vim'

" plugin to python debugger. This plugin is deprecated
" in favor of vimspector with debugpy
Plug 'gotcha/vimpdb'

" a wrapper around git. for example, :GBlame will show
" git blame window to the left
Plug 'tpope/vim-fugitive'

"ALE (Asynchronous Lint Engine)
"is a plugin providing linting (syntax checking and semantic errors) in NeoVim 0.2.0+
"it checks your code interactively and shows error mark in the sign coloum`
Plug 'dense-analysis/ale'

" collection of files that uses fzf. For example FZFTags and FZFWindows
Plug 'yuki-ycino/fzf-preview.vim'

" great plugin for creating commits in vim. just type :Magit
" get help in the new window by pressing ?
Plug 'jreybert/vimagit'
Plug 'artur-shaik/vim-javacomplete2'

" presonal wiki for vim. similar to emacs org
Plug 'vimwiki/vimwiki'

" adds todo funcionality for vimwiki
Plug 'aserebryakov/vim-todo-lists'

" adds cpp competions with clang ide assistant (great)
Plug 'justmao945/vim-clang'

call plug#end()

" Generation Parameters
let g:ctagsFilePatterns = '\.uml$|\.wiki$|\.c$|\.cc$|\.cpp$|\.yml|\.cxx$|\.h$|\.hh$|\.hpp$|\.py$|\.mk$|\.bash$|\.sh$|\.vim$|make|Make|\.json$|\.j2|.rc|\.java$'
"let g:ctagsOptions = '--languages=C,C++,Vim,Python,Make,Sh,JavaScript,java --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --tag-relative'
let g:ctagsOptions = '-R --exclude=build --languages=C,C++,Vim,Python,Make,Sh,JavaScript,java --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --tag-relative'
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

function! GetGutctagsFN()
    return gutentags#get_cachefile(gutentags#get_project_root($PWD), 'LASTSESSION.vim')
endfunction

function! GetBufferDirectory()
    let l:path = expand("%:p:h")
    if l:path == ""
        return $PWD
    endif
    return l:path
endfunction

function! GetProjectRoot()
    return gutentags#get_project_root(GetBufferDirectory())
endfunction

" Generate All
function! ZGenerateAll()
    let l:pr = GetProjectRoot()
    let l:gutctags = l:pr . '/' . '.gutctags'
    let l:cscope_files = gutentags#get_cachefile(l:pr, '.cscope.files')
    copen
    exec ":AsyncRun cd '" . l:pr . "' && echo '" . g:ctagsOptions . "' > " . l:gutctags . " && sed -i 's/ /\\n/g' " . l:gutctags . " && ag -l -i -g '" . g:ctagsFilePatterns . "' > " . l:cscope_files . " && (git ls-files >> " . l:cscope_files . " 2> /dev/null || true) &&  sort -u " . l:cscope_files . " > /tmp/cscope.tmp.$$ && rm " . l:cscope_files . " && mv /tmp/cscope.tmp.$$ " . l:cscope_files
endfunction

" Install Mapping
nnoremap <leader>zi :call ZInstall()<CR>

" Generate All Mapping
nnoremap <leader>zg :call ZGenerateAll()<CR>

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
nnoremap <C-L> :NERDTreeToggle<CR>:wincmd w<CR>:TagbarToggle<CR>

" Ctrlp
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

"neovim python
" let g:python3_host_prog="/home/ANT.AMAZON.COM/kahayaro/.pyenv/shims/python"

"python linting
" Check Python files with flake8 and pylint.
"let b:ale_linters = ['flake8', 'pylint']
"let g:ale_linters = { 'python': ['pylint', 'mypy']}
" Fix Python files with autopep8 and yapf.
let b:ale_fixers = ['autopep8', 'yapf']
" Disable warnings about trailing whitespace for Python files.
let b:ale_warn_about_trailing_whitespace = 0
let g:ale_python_pylint_executable = 'python3'
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
"let g:gutentags_modules = ['cscope']
" enable gtags module
let g:gutentags_modules = ['cscope', 'ctags', 'gtags_cscope']

" config project root markers.
let g:gutentags_project_root = ['.root', '.git']

" generate datebases in my cache directory, prevent gtags files polluting my p                                                                                                             roject
let g:gutentags_cache_dir = expand('~/.cache/tags')

" forbid gutentags adding gtags databases
let g:gutentags_auto_add_gtags_cscope = 1

let g:gutentags_plus_nomap = 1
set statusline+=%{gutentags#statusline()}
let g:gutentags_define_advanced_commands = 1
" Fzf
set rtp+=~/.fzf

function DoShowFiles()
    let l:pr = GetProjectRoot()
    let l:cscope_files = gutentags#get_cachefile(l:pr, '.cscope.files')
    let $FZF_DEFAULT_COMMAND = "if [ -s '" . l:cscope_files . "' ]; then cat '" . l:cscope_files . "'; else ag -l '' '" . l:pr . "'; fi"
    " Empty value to disable preview window altogether
    let g:fzf_preview_window = ''
    exec ":Files " . l:pr
endfunction

nnoremap <C-p> :call DoShowFiles()<CR>
nnoremap <C-n> :Tags<CR>

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
" noremap <F1> <C-w><C-p>
" noremap <F2> <C-w><C-w>
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabp<CR>
nnoremap <C-t> :tabnew<CR>
" noremap <F6> :bp<CR>
" noremap <F7> :bn<CR>
noremap <F5> :set nu!<CR>:set paste!<CR>
set spelllang=en
"enable ddd  working with the mouse
set mouse=a
set noerrorbells visualbell t_vb=
"enable spell checking
set spell

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

function! GetLastSessionFn()
    return gutentags#get_cachefile(gutentags#get_project_root($PWD), 'LASTSESSION.vim')
endfunction

function! IsProj()
    return g:gutentags_enabled || filereadable(GetLastSessionFn())
endfunction

function! SetGuttentagsEnable()
    if argc() > 0
        let g:gutentags_enabled = 0
    endif
endfunction

function! RestoreSess()
    try
        if argc() > 0
            let g:do_save_session = 0
        endif

        if g:do_restore_last_session > 0 && argc() == 0 && IsProj() && filereadable(GetLastSessionFn())
            exec "source " . GetLastSessionFn()
        endif
    catch /.*/
        let g:do_save_session = 0
    endtry
endfunction

function! SaveSess()
    echom "do_save_session=" . g:do_save_session
    call KillDbgBuf()
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
     noremap ;c :call vimspector#Continue<CR>
     noremap ;b :call vimspector#ToggleBreakpoint()<CR>
     noremap ;w :call WatchVar()<CR>
     noremap ;1 :call vimspector#StepOver()<CR>
     noremap ;i :call vimspector#StepInto()<CR>
     noremap ;o :call vimspector#StepOut()<CR>
     noremap ;t :call SafeCloseVimspector()<CR>
     noremap ;` :call KillDbgBuf()
augroup end

function! MoveBuf(dr)
    let l:mybuf = bufnr("%")
    let l:myline = line(".")
    let l:mycol = col(".")
    let l:mywin = bufwinnr("%")
    exec "wincmd " . a:dr
    let l:otherwin = bufwinnr("%")
    let l:otherline = line(".")
    let l:othercol = col(".")
    if l:mywin != l:otherwin
        let l:otherbuf = bufnr("%")
        exec ":b " . l:mybuf
        call cursor(l:myline, l:mycol)
        exe l:mywin . "wincmd w"
        exe ':b#'
        return l:otherwin
    endif
    return l:mywin
endfunction

function! MoveBufAndStay(dr)
    let l:target = MoveBuf(a:dr)
    exec l:target . "wincmd w"
endfunction

"move window to the previous tab
function MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    sp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunction

" Move window to the next tab
function MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    sp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunction


augroup buffmove
    nnoremap 2<Right> :call MoveBuf("l")<CR>
    nnoremap 2<Left> :call MoveBuf("h")<CR>
    nnoremap 2<Down> :call MoveBuf("j")<CR>
    nnoremap 2<Up> :call MoveBuf("k")<CR>

    nnoremap 3<Right> :call MoveBufAndStay("l")<CR>
    nnoremap 3<Left> :call MoveBufAndStay("h")<CR>
    nnoremap 3<Down> :call MoveBufAndStay("j")<CR>
    nnoremap 3<Up> :call MoveBufAndStay("k")<CR>

    " in quickfix window pressing 4 and arrow will open the link in a new
    " buffer according to the arrow direction
    autocmd! Filetype qf nnoremap <buffer> 4<Right> <C-w><Enter><C-w>L | nnoremap <buffer> 4<Left> <C-w><Enter><C-w>H | nnoremap <buffer> 4<Up> <C-w><Enter><C-w>K | nnoremap <buffer> 4<Down> <C-w><Enter><C-w>J

    nnoremap 4<Right> :call MoveToNextTab()<CR><C-w>H
    nnoremap 4<Left> :call MoveToPrevTab()<CR><C-w>H
augroup end

"toggles whether or not the current window is automatically zoomed
function! ToggleMaxWins()
  if exists('g:windowMax')
    au! maxCurrWin
    wincmd =
    unlet g:windowMax
  else
    augroup maxCurrWin
        au! BufEnter * wincmd _ | wincmd |
        "
        " only max it vertically
        " au! WinEnter * wincmd _
    augroup END
    do maxCurrWin WinEnter
    exe ": wincmd _ | wincmd |"
    let g:windowMax=1
  endif
endfunction
nnoremap <Leader>z :call ToggleMaxWins()<CR>

augroup my_tmux
    autocmd!
    autocmd bufenter * call Panetitle()
    autocmd bufenter * call Escapeins()
    autocmd BufEnter * call LoadCursorShapes()
    if v:servername == ""
        call remote_startserver(getpid())
    endif
    noremap <silent> <Leader>bx :q<CR>
    noremap <silent> <Leader>bc :cclose<CR>
    "noremap <silent> <Leader>z :tab split<CR>
    noremap <Leader>w :WinResizerStartResize<CR>
    noremap <Leader>? :Maps<CR>
    noremap <Leader>?? :Commands<CR>SplitVAndSwap()<cr>
    noremap <Leader>h :History<CR>
    noremap <Leader>% :call SplitVAndSwap()<cr>
    noremap <Leader>" :call SplitAndSwap()<cr>
    noremap <Leader>b :bufdo bd<cr>
    "remove trailing white spaces in c, c++
    autocmd InsertLeave *.c,*.sh,*.java,*.j2,*.cpp,*.html,*.py,*.json,*.yml,*.mk,*.vim,COMMIT_EDITMSG call EraseTralingWs()
    autocmd BufWritePre,BufUnload,QuitPre * :call RemoveWhiteSpacesFromGitHunks()
    autocmd VimLeave * call SaveSess()
    autocmd VimLeavePre * :tabdo NERDTreeClose
    autocmd VimLeavePre * :tabdo TagbarClose
    autocmd VimLeavePre * :tabdo cclose
    autocmd VimEnter * nested call RestoreSess()
    autocmd VimEnter * nested call SetGuttentagsEnable()
    vnoremap <silent><Leader>y "yy <Bar> :call CopyToX11Clipboard()<CR>
    nnoremap <silent> <leader>p :call PasteFromX11() <CR>
    vnoremap <silent> <LeftRelease> y <Bar> :call UpdateX11Clipboard()<CR>
    noremap <silent> <RightMouse> :Maps<CR>
    "execute("command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis")
    nnoremap z= :call FzfSpell()<CR>
    inoremap <Leader>li :LinuxCodingStyle<cr>
    let g:linuxsty_patterns = [ "/kernel/", "/linux/"]
    nnoremap <C-d> :call InsertDate()<cr>
    nnoremap <F10> :call LaunchIpythonInTmux()<CR>
    nnoremap <F1> :call OpenVimTmuxTerm()<CR>
    nnoremap <F2> :call OpenVimBufTmuxTerm()<CR>
    inoremap <C-d> <C-o>:call InsertDate() <CR>
    :map <Leader>tt <Plug>VimwikiToggleListItem
    "replace all occurences of the word under cursor
    :nnoremap <Leader>s :call ReplaceWordUnderCursor()<CR>
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

augroup end

function! BrazilGetAllTests()
    let res = []
    let all_files = split(globpath("test/*", "test_*"), "\n") + split(globpath("test_integ", "test_*"), "\n")
    let fnd = 0
    for f in all_files
        let tests = systemlist("grep -E '^def +test_.*\\(.*\\).*:' " . f  . " | sed 's/^ *def *test_/test_/' | sed 's/(.*).*://'")
        for test in tests
            let test_str = f . "::" . test
            if test_str != g:brazilLastTest
                let res = add(res, test_str)
            else
                let fnd = 1
            endif
        endfor
    endfor
    if g:brazilLastTest != "" && fnd == 1
        let res = add(res, g:brazilLastTest)
    endif
    let res = reverse(res)
    return res
endfunction

function! BrazilRunTest()
    let y = BrazilGetAllTests()
    let g:brazilTesting = 1
    let l = len(y) + 2
    if l > 15
        let l = 15
    endif
    call fzf#run({'source': y, 'sink': function('BrazilTest'), 'down': l})
endfunction

function! BrazilTestFinished()
    if g:brazilTesting != 0
        let g:brazilTesting = 0
        "let v:errorformat = g:brazilSavedEf
    endif
endfunction

function! BrazilBuild()
    copen
    call BrazilSetErrFormat()
    :wincmd J
    :AsyncRun brazil-build
endfunction

function! BrazilBuildRelease()
    copen
    call BrazilSetErrFormat()
    exec ":AsyncRun bash -c \"brazil-build release 2>&1 | ~/dotfiles/vimmux/replace_top_dir.sh\""
endfunction

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

function! BrazilTest(testName)
    copen
    let g:brazilSavedEf = &errorformat
    "the next errorformat match python interpreter error
    ":set errorformat=\ %#File\ \"%f\"\\,\ line\ %l\\,%m
    call BrazilSetErrFormat()
    "the next errorformat matches python traback printout

    let g:brazilLastTest = a:testName
    exec ":AsyncRun GEVENT_SUPPORT=True brazil-test-exec pytest -s -vv " . a:testName
    "test/test_orchestration_component.py::test_get_update_replication_info
endfunction

function! BrazilRecuriseBuild()
    copen
    call BrazilSetErrFormat()
    :AsyncRun brazil-recursive-cmd brazil-build
endfunction

function! LaunchIpythonInTmux()
    let g:ipythPaneId = system("cd test && tmux splitw -v -P -F \"#{pane_id}\" brazil-test-exec ipython")
    exec ":call system('tmux set -q @vim_server " . v:servername . "')"
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
    exec ":AsyncRun ~/dotfiles/vimmux/start_show_tb.sh \\" . a:paneid
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

"cool buffer switcher"
"nnoremap <silent> <Leader><Enter> :FzfPreviewBuffers<CR>
nnoremap <silent> <Leader><Enter> :Buffers<CR>
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

augroup AgGroup
    nnoremap <C-A> :call AgWord()<CR>
    vnoremap <C-A> :call AgVisual()<CR>
augroup end
function! Agg(t)
    copen
    exec ":AsyncRun ag " . shellescap(a:t)
endfunction

function AgWord()
    if g:asyncrun_status == 'running'
        :AsyncStop
        throw "job is being executed in background, wait a second and try again"
    endif
    let wordUnderCursor = expand("<cword>")
    call AgThat(wordUnderCursor)
endfunction

function AgThat(t)
    :set errorformat=%f:%l:%m
    copen
    let l:pr = GetProjectRoot()
    let cmd = ":AsyncRun git grep -n \"" . a:t . "\""
    exec cmd
endfunction

function AgVisual()
    if g:asyncrun_status == 'running'
        :AsyncStop
        throw "job is being executed in background, wait a second and try again"
    endif
    let line_start = getpos("'<")[1]
    let line_end = getpos("'>")[1]
    if line_start != line_end
        throw "multi line search is not supported"
    endif
    let searchWord = s:get_visual_selection()
    if searchWord == ""
        return
    endif
    call AgThat(searchWord)
endfunction

function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
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
" autocmd BufReadPost * :DetectIndent

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
