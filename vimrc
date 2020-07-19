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

    autocmd VimEnter * PlugInstall
endif

" Required
call plug#begin(expand(s:portable.'/plugged'))

Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'Chiel92/vim-autoformat'
Plug 'niklaas/lightline-gitdiff'
Plug 'takac/vim-hardtime'
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}

call plug#end()

"********************************************************************************
"" Basic Setup
"********************************************************************************

set hlsearch
set nohidden
set showcmd
set nowrap
set cursorline
set number relativenumber
set path=.,,**

" Tabs
set tabstop=4
set shiftwidth=4
set expandtab

" Netrw
let g:netrw_liststyle = 3
let g:netrw_fastbrowse = 0

" Match angle brackets
set matchpairs+=<:>

" Undo files
if !isdirectory(expand(s:portable.'/undo'))
    call mkdir(expand(s:portable.'/undo'), '', 0700)
endif
exe 'set undodir='.expand(s:portable."/undo")
set undofile

" Write the content before :make
set autowrite

" Hardtime
let g:hardtime_default_on = 1
let g:list_of_normal_keys = ["h", "j", "k", "l", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_visual_keys = ["h", "j", "k", "l", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:hardtime_timeout = 200

command! -nargs=1 Silent
            \ | execute ':silent !'.<q-args>

" Remember cursor position
augroup vimrc-remember-cursor-position
    au!
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
                \ | exe "normal! g`\""
                \ | endif
augroup END

" Fugitive buffer readonly
augroup vimrc-fugitive-buffer-readonly
    au!
    au BufReadPost fugitive://* setlocal nomodifiable readonly
augroup END

" Autoformat on save
augroup vimrc-autoformat
    au!
    au BufWrite * if get(g:, 'autoformat', 0)
                \ | :Autoformat<CR>
                \ | endif
augroup END

" Force refresh status-line when getentags updates
augroup getentags-status-line-refresher
    au!
    au User GutentagsUpdating call lightline#update()
    au User GutentagsUpdated call lightline#update()
augroup END

"*****************************************************************************
"" Visual Settings
"*****************************************************************************

colorscheme gruvbox
set background=dark
set t_Co=256

function! LightlineMode()
    return expand('%') =~# '^fugitive://' ? 'GIT':
                \ lightline#mode()
endfunction
function! LightlineAutoformat()
    return get(g:, 'autoformat', 0) ? '=' : ''
endfunction
let g:lightline = {
            \ 'active': {
            \   'left': [ [ 'mode' ],
            \             [ 'readonly', 'filename', 'modified' ],
            \             [ 'gitdiff', 'ctags' ] ],
            \   'right': [ [ 'autoformat' ],
            \              [ 'percent' ],
            \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
            \ },
            \ 'component_function': {
            \   'mode': 'LightlineMode',
            \   'autoformat': 'LightlineAutoformat',
            \ },
            \ 'component_expand': {
            \   'gitdiff': 'lightline#gitdiff#get',
            \   'ctags': 'gutentags#statusline',
            \ },
            \ 'component_type': {
            \   'gitdiff': 'middle',
            \ },
            \ }
let g:lightline.colorscheme = 'gruvbox'

"*****************************************************************************
"" Key Bindings
"*****************************************************************************

" Copy/Paste/Cut
noremap YY "+y<CR>
noremap XX "+x<CR>

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

" Toggle autoformat
nnoremap <silent> == :let g:autoformat = !get(g:, 'autoformat', 0)<CR>

"*****************************************************************************
"" Go
"*****************************************************************************

au BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

let g:go_textobj_enabled = 0
let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0

augroup go
    au!
    au Filetype go nmap gd <Plug>(go-def)
    au Filetype go nmap gh <Plug>(go-info)
augroup END
