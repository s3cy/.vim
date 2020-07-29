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
        echoerr "You have to install curl or first install vim-plug yourself!"
        execute "q!"
    endif
    echo "Installing Vim-Plug..."
    echo ""
    silent exec "!\curl --insecure -fLo " . vimplug_exists . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

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
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

call plug#end()

"********************************************************************************
"" Basic Setup
"********************************************************************************

set hlsearch
set showcmd
set nowrap
set cursorline
set number relativenumber
set path=.,,**
set matchpairs+=<:>
set signcolumn=no

let g:go_highlight_trailing_whitespace_error = 0

" Tabs
set tabstop=4
set shiftwidth=4
set expandtab

" Abbr
cnoreabbr ! AsyncRun

" Undo files
if !isdirectory(expand(s:portable.'/undo'))
    call mkdir(expand(s:portable.'/undo'), '', 0700)
endif
exe 'set undodir='.expand(s:portable."/undo")
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

" Remember cursor position
augroup vimrc-remember-cursor-position
    au!
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
                \ | exe "normal! g`\""
                \ | endif
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

"*****************************************************************************
"" Visual Settings
"*****************************************************************************

colorscheme gruvbox
set background=dark
set t_Co=256

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

" Shell-style command moves
cnoremap <C-a> <HOME>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>

" Clear the highlighting of :set hlsearch
nnoremap <silent> <C-n> :nohlsearch<CR>

" Use <esc> to exit terminal insert mode
tnoremap <esc> <C-\><C-n>

"*****************************************************************************
"" Lsp
"*****************************************************************************

let g:lsp_diagnostics_enabled = 0
let g:lsp_auto_enable = 0
let s:lsp_servers = []
let s:lsp_allowlist = []
let g:lsp_confirmed = 0

func! SetLspTagFunc() abort
    let g:gutentags_enabled = 0
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
    if g:lsp_confirmed == 0 && index(s:lsp_allowlist, &ft) >= 0
        if confirm('LSP is available, enable it?', "&yes\n&no", 1) == 1
            call lsp#enable()
        endif
        let g:lsp_confirmed = 1
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
