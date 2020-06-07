"*****************************************************************************
"" Vim-PLug core
"*****************************************************************************
let vimplug_exists=expand($XDG_CONFIG_HOME.'/nvim/autoload/plug.vim')

if !filereadable(vimplug_exists)
    if !executable("curl")
        echoerr 'You have to install curl or first install vim-plug yourself!'
        execute 'q!'
    endif
    echo 'Installing Vim-Plug...'
    echo ''
    silent exec '!\curl -fLo '.vimplug_exists.' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    autocmd VimEnter * PlugInstall
endif

call plug#begin(expand($XDG_CONFIG_HOME.'/nvim/plugged'))

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'craigemery/vim-autotag'
Plug 'airblade/vim-gitgutter'

call plug#end()

"*****************************************************************************
"" Basic Setup
"*****************************************************************************

set number relativenumber
set path+=**

" Tabs
set tabstop=4
set shiftwidth=4
set expandtab

" Undo files
let &undodir = expand($XDG_CONFIG_HOME.'/nvim/undo')
set undofile

" Remove trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e

"*****************************************************************************
"" Visual Settings
"*****************************************************************************

colorscheme gruvbox

let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'

"*****************************************************************************
"" Key Bindings
"*****************************************************************************

let g:mapleader = ' '

" Copy/Paste/Cut
noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>

" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-k>j
noremap <C-l> <C-l>j
noremap <C-h> <C-h>j

" Clear the highlighting of :set hlsearch
nnoremap <silent> <C-n> :nohlsearch<CR>


"*****************************************************************************
"" Terminal
"*****************************************************************************

tnoremap <esc> <C-\><C-n>

au TermOpen * setlocal nonumber norelativenumber
au TermOpen * startinsert
