"********************************************************************************
"" Portable
"********************************************************************************

set nocompatible
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
let s:portable = expand('<sfile>:p:h')
let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)

"********************************************************************************
"" Vim-Plug core
"********************************************************************************

let vimplug_exists=expand(s:portable.'/autoload/plug.vim')

if !filereadable(vimplug_exists)
    if !executable("curl")
        echoerr 'You have to install curl or first install vim-plug yourself!'
        execute 'q!'
    endif
    echo 'Installing Vim-Plug...'
    echo ''
    silent exec '!\curl --insecure -fLo ' . vimplug_exists .
                \ ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    au VimEnter * PlugInstall
endif

" Required
call plug#begin(expand(s:portable.'/plugged'))

Plug 'flazz/vim-colorschemes'
Plug 'justinmk/vim-dirvish'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mhinz/vim-signify'
Plug 'prabirshrestha/vim-lsp'
Plug 'skywind3000/asyncrun.vim'
Plug 'takac/vim-hardtime'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

call plug#end()

"********************************************************************************
"" Basic Setup
"********************************************************************************

set hlsearch
set showcmd
set nowrap
set number relativenumber
set signcolumn=no
set tabstop=4
set shiftwidth=4
set path=.,,**
set matchpairs+=<:>
set cscopequickfix=g-,s-,c-,f-,i-,t-,d-,e-,a-

let g:go_highlight_trailing_whitespace_error = 0

" Bin directory for all related executables
let s:bin_dir = expand(s:portable . '/bin')
if !isdirectory(s:bin_dir)
    call mkdir(s:bin_dir, '', 0700)
endif
if stridx($PATH, s:bin_dir) < 0
    let $PATH .= ':' . s:bin_dir
endif

" Undo files
let s:undo_dir = expand(s:portable . '/.cache/undo')
if !isdirectory(s:undo_dir)
    call mkdir(s:undo_dir, 'p', 0700)
endif
exe 'set undodir=' . s:undo_dir
set undofile

" AsyncRun
let g:asyncrun_save = 2
let g:asyncrun_exit = 'echo g:asyncrun_status . " " . g:asyncrun_code'

" Hardtime
let g:hardtime_default_on = 1
let g:list_of_normal_keys = ["h", "j", "k", "l", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_visual_keys = ["h", "j", "k", "l", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:hardtime_timeout = 200

" Dirvish
let g:loaded_netrwPlugin = 1 " disable netrw
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>

" Gutentags
let g:gutentags_file_list_command = 'git ls-files'
let g:gutentags_modules = []
if executable('ctags')
    let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope')
    let g:gutentags_modules += ['gtags_cscope']
endif
let s:tags_dir = expand(s:portable . '/.cache/tags')
if !isdirectory(s:tags_dir)
    call mkdir(s:tags_dir, 'p', 0700)
endif
let g:gutentags_cache_dir = s:tags_dir

" Remember cursor position
augroup vimrc-remember-cursor-position
    au!
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
                \ | exe "normal! g`\""
                \ | endif
augroup END

" Automatically set cursorline
set cursorline
augroup vimrc-auto-cursorline
    au!
    au WinEnter * set cursorline
    au WinLeave * set nocursorline
augroup END

" Change comment style for some filetype
augroup vimrc-commentary-comment-style
    au!
    au FileType c,cpp setlocal commentstring=//\ %s
augroup END

" Fugitive buffer readonly
augroup vimrc-fugitive-buffer-readonly
    au!
    au BufReadPost fugitive://* setlocal nomodifiable readonly
augroup END

" Terminal provides a new command `drop` to drop files to current session
let s:term_vim_script = expand(s:bin_dir . '/drop')
if !filereadable(s:term_vim_script)
    " Have to use a shell env to prevent vim from substituting '#' in the
    " following encoded script.
    " Cannot use `redir` either becuase it outputs an extra new line at the
    " top of a file (We need `#!/bin/sh` at exactly the first line to make a
    " script to work).
    let $XXX_DUMMY = "#!/bin/sh\n\n# AUTO-GENERATED BY VIMRC. DO NOT MODIFY.\n\nif [ -z \"$1\" ]; then\n\techo \"usage: drop {filename}\"\n\texit 0\nfi\n\nif [ -z \"$VIM_TERMINAL\" ]; then\n\techo \"Must be called inside vim\"\n\texit 1\nfi\n\nabsolute_path() {\n\tlocal result=\"\"\n\tif [ -x \"$(which realpath 2> /dev/null)\" ]; then\n\t\tresult=\"$(realpath -s \"\"\"$1\"\"\" 2> /dev/null)\"\n\tfi\n\tif [ -z \"$result\" ] && [ -x \"$(which perl 2> /dev/null)\" ]; then\n\t\tresult=\"$(perl -MCwd -e 'print Cwd::realpath($ARGV[0])' \"\"\"$1\"\"\")\"\n\tfi\n\tif [ -z \"$result\" ] && [ -x \"$(which python 2> /dev/null)\" ]; then\n\t\tresult=\"$(python -c 'import sys, os;sys.stdout.write(os.path.abspath(sys.argv[1]))' \"\"\"$1\"\"\")\"\n\tfi\n\tif [ -z \"$result\" ] && [ -x \"$(which python3 2> /dev/null)\" ]; then\n\t\tresult=\"$(python3 -c 'import sys, os;sys.stdout.write(os.path.abspath(sys.argv[1]))' \"\"\"$1\"\"\")\"\n\tfi\n\tif [ -z \"$result\" ] && [ -x \"$(which python2 2> /dev/null)\" ]; then\n\t\tresult=\"$(python2 -c 'import sys, os;sys.stdout.write(os.path.abspath(sys.argv[1]))' \"\"\"$1\"\"\")\"\n\tfi\n\tif [ -z \"$result\" ] && [ -x \"$(which realpath 2> /dev/null)\" ]; then\n\t\tresult=\"$(realpath \"\"\"$1\"\"\")\"\n\tfi\n\tif [ -z \"$result\" ]; then\n\t\tresult=\"$1\"\n\tfi\n\techo $result\n}\n\nname=\"$(absolute_path \"\"\"$1\"\"\")\"\nprintf '\\033]51;[\"call\", \"Tapi_TerminalEdit\", [\"%s\"]]\\007' \"$name\"\n"
    silent exe '!echo $XXX_DUMMY > ' . s:term_vim_script

    call setfperm(s:term_vim_script, 'r-x------')
endif
" invoked from a vim terminal buffer. See `:h term_setapi`
func! Tapi_TerminalEdit(bid, arglist)
    let l:name = (type(a:arglist) == v:t_string) ? a:arglist : a:arglist[0]
    silent exec 'drop ' . fnameescape(name)
    return ''
endfunc

"*****************************************************************************
"" Visual Settings
"*****************************************************************************

" Color
colorscheme gruvbox
set background=dark

" Statusline
func! ActiveStatus() abort
    let l:line = ''
    if &buftype ==# 'terminal'
        let l:line .= '%f'
        let l:line .= '%=%P'
        return l:line
    endif
    let l:line .= '%f %r'
    if &ro ==# ''
        let l:line .= '%m'
    endif
    let l:line .= '%#StatusLineNC#'
    let l:line .= ' '
    let l:line .= '%{sy#repo#get_stats_decorated()}'
    let l:line .= g:asyncrun_status ==# 'running' ? '[asyncrun]' : ''
    let l:line .= "%{gutentags#statusline('[', ']')}"
    let l:line .= '%='
    if &ff !=# 'unix' || &fenc !=# 'utf-8'
        let l:line .= &ff
        let l:line .= '[' . (strlen(&fenc) ? &fenc : 'none') . ']'
    endif
    let l:line .= ' '
    let l:line .= GetLspServerStatus()
    let l:line .= '%y %P'
    return l:line
endfunc

func! InactiveStatus() abort
    let l:line = ''
    let l:line .= '%f%=%P'
    return l:line
endfunc

set statusline=%!ActiveStatus()
augroup vimrc-statusline
    au!
    au WinEnter * setlocal statusline=%!ActiveStatus()
    au WinLeave * setlocal statusline=%!InactiveStatus()
    au User GutentagsUpdated setlocal statusline=%!ActiveStatus()
    au User lsp_server_exit setlocal statusline=%!ActiveStatus()
augroup END

"*****************************************************************************
"" Key Bindings
"*****************************************************************************

" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

" Switching tabs
nnoremap <C-q> <C-w>gt
tnoremap <C-q> <C-w>gt

" Shell-style command moves
cnoremap <C-a> <HOME>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>

" Clear the highlighting of :set hlsearch
nnoremap <silent> <C-n> :nohlsearch<CR>

" Double tab esc to exit terminal insert mode
tnoremap <esc><esc> <C-\><C-n>

" Cscope
func! CscopeFind(cmd, query, search_term)
    exe 'normal! mY'
    cclose

    let l:current_file = @%
    let l:view = winsaveview()
    let l:search_query = a:cmd . " find " . a:query . " " . a:search_term
    let g:debug = l:search_query

    let v:errmsg = ''
    silent! keepjumps exe search_query
    if strlen(v:errmsg) > 0 | echohl ErrorMsg | echo(v:errmsg) | echohl None | endif

    if len(getqflist()) > 1
        if l:current_file != @%
            exe 'normal! `Y'
            bdelete #
        endif
        call winrestview(l:view)

        botright copen
    endif
endfunc
nnoremap gr :call CscopeFind('cs', 's', expand('<cword>'))<CR>
nnoremap gR :call CscopeFind('cs', 'c', expand('<cword>'))<CR>
nnoremap gF :call CscopeFind('cs', 'f', expand('<cfile>'))<CR>
nnoremap gI :call CscopeFind('cs', 'i', expand('<cfile>'))<CR>

"*****************************************************************************
"" Lsp
"*****************************************************************************

let g:lsp_diagnostics_enabled = 0
let g:lsp_auto_enable = 0
let s:lsp_servers = []
let s:lsp_allowlist = []
let s:lsp_confirmed = 0

func! SetLspTagFunc() abort
    if exists('+tagfunc')
        setlocal tagfunc=lsp#tagfunc
    else
        nmap <buffer> <C-]> <plug>(lsp-definition)
    endif
endfunc

func! OnLspBufferEnabled() abort
    setlocal omnifunc=lsp#complete
    call SetLspTagFunc()
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> ga <plug>(lsp-code-action)
    au BufWritePre <buffer> LspDocumentFormatSync
endfunc

func! OnLspServerInit() abort
    let l:server_names = lsp#get_server_names()
    for l:server_name in l:server_names
        if index(s:lsp_servers, l:server_name) < 0
            let l:server = lsp#get_server_info(l:server_name)
            if has_key(l:server, 'allowlist') && index(l:server['allowlist'], &ft) >= 0
                call add(s:lsp_servers, l:server_name)
            endif
        endif
    endfor
endfunc

func! GetLspServerStatus() abort
    let l:statuses = []
    for l:server in s:lsp_servers
        let l:status = lsp#get_server_status(l:server)
        call add(l:statuses, l:status == 'running' ? l:server : l:server . ':' . l:status)
    endfor
    return join(l:statuses, ',')
endfunc

func! ConfirmToEnableLsp()
    if s:lsp_confirmed == 0 && index(s:lsp_allowlist, &ft) >= 0
        if confirm('LSP is available, enable it?', "&yes\n&no", 1) == 1
            call lsp#enable()
        endif
        let s:lsp_confirmed = 1
    endif
endfunc

augroup vimrc-lsp
    au!
    au User lsp_buffer_enabled call OnLspBufferEnabled()
    au User lsp_server_init call OnLspServerInit()

    if executable('gopls')
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'gopls',
                    \ 'cmd': { server_info->['gopls'] },
                    \ 'allowlist': ['go'] })
        let s:lsp_allowlist += ['go']
    endif

    if executable('rls')
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'rls',
                    \ 'cmd': { server_info->['rustup', 'run', 'stable', 'rls']},
                    \ 'allowlist': ['rust'] })
        let s:lsp_allowlist += ['rust']
    endif

    au BufReadPost * call ConfirmToEnableLsp()
augroup END
