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

" Required:
call plug#begin(expand('~/.vim/plugged'))

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

call plug#end()

"********************************************************************************
"" Basic Setup
"********************************************************************************

set hlsearch
set number relativenumber
set path=.,,**

" Tabs
set tabstop=4
set shiftwidth=4
set expandtab

" Undo files
if !isdirectory(expand("~/.vim/undo"))
    call mkdir(expand("~/.vim/undo"), "", 0700)
endif
set undodir=~/.vim/undo
set undofile

" Write the content before :make
set autowrite

" Remove trailing spaces on save
augroup vimrc-trim-spaces-on-save
    au!
    au BufWritePre * :%s/\s\+$//e
augroup END

"*****************************************************************************
"" Visual Settings
"*****************************************************************************

colorscheme gruvbox
set background=dark

let g:lightline = {}
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

" Clear the highlighting of :set hlsearch
nnoremap <silent> <C-n> :nohlsearch<CR>
