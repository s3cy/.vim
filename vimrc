"********************************************************************************
"" Vim-Plug core
"********************************************************************************

let vimplug_exists=expand('~/.vim/autoload/plug.vim')

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
call plug#begin(expand('~/.vim/plugged'))

Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'craigemery/vim-autotag'
Plug 'Chiel92/vim-autoformat'
Plug 'niklaas/lightline-gitdiff'
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}

call plug#end()

"********************************************************************************
"" Basic Setup
"********************************************************************************

set hlsearch
set showcmd
set nowrap
set number relativenumber
set path=.,,**

" Tabs
set tabstop=4
set shiftwidth=4
set expandtab

" Tree view
let g:netrw_liststyle = 3

" Undo files
if !isdirectory(expand("~/.vim/undo"))
    call mkdir(expand("~/.vim/undo"), "", 0700)
endif
set undodir=~/.vim/undo
set undofile

" Write the content before :make
set autowrite

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
let g:lightline = {
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'readonly', 'filename', 'modified' ],
            \             [ 'gitdiff' ] ]
            \ },
            \ 'component_function': {
            \   'mode': 'LightlineMode',
            \ },
            \ 'component_expand': {
            \   'gitdiff': 'lightline#gitdiff#get',
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

"*****************************************************************************
"" Go
"*****************************************************************************

au BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

let g:go_textobj_enabled = 0
let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0

augroup go
    au!
    au Filetype go nmap <C-]> <Plug>(go-def)
    au Filetype go nmap <C-t> <Plug>(go-def-pop)
    au Filetype go nmap gh <Plug>(go-info)
augroup END
