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

function! ActiveStatus() abort
    let line = ''
    if &buftype ==# 'terminal'
        let line .= '%f'
        let line .= '%=%P'
        return line
    endif
    let line .= '%f %r'
    if &ro ==# ''
        let line .= '%m'
    endif
    let line .= '%#StatusLineNC#'
    let line .= ' '
    let line .= '%{sy#repo#get_stats_decorated()}'
    let line .= g:asyncrun_status ==# 'running' ? '[asyncrun]' : ''
    let line .= "%{gutentags#statusline('[', ']')}"
    let line .= '%='
    if &ff !=# 'unix' || &fenc !=# 'utf-8'
        let line .= &ff
        let line .= '[' . (strlen(&fenc) ? &fenc : 'none') . ']'
    endif
    let line .= ' %y %P'
    return line
endfunction

function! InactiveStatus() abort
    let line = ''
    let line .= '%f%=%P'
    return line
endfunction

set statusline=%!ActiveStatus()
augroup vimrc-statusline
    au!
    au WinEnter * setlocal statusline=%!ActiveStatus()
    au WinLeave * setlocal statusline=%!InactiveStatus()
    au User GutentagsUpdated setlocal statusline=%!ActiveStatus()
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

if executable('gopls')
    au User lsp_setup call lsp#register_server({
            \ 'name': 'gopls',
            \ 'cmd': { server_info->['gopls'] },
            \ 'allowlist': ['go'] })
endif

function! SetLspTagFunc() abort
    let g:gutentags_enabled = 0
    if exists('+tagfunc')
        setlocal tagfunc=lsp#tagfunc
    else
        nmap <buffer> <C-]> <plug>(lsp-definition)
    endif
endfunc

function! OnLspBufferEnabled() abort
    setlocal completeopt=menu
    setlocal omnifunc=lsp#complete
    call SetLspTagFunc()
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> ga <plug>(lsp-code-action)
    au BufWritePre <buffer> LspDocumentFormatSync
endfunction

augroup vimrc-lsp
    au!
    au User lsp_buffer_enabled call OnLspBufferEnabled()
augroup END

let g:lsp_diagnostics_enabled = 0
let g:lsp_textprop_enabled = 0
