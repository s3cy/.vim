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

    au VimEnter * PlugInstall
endif

call plug#begin(expand($XDG_CONFIG_HOME.'/nvim/plugged'))

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'craigemery/vim-autotag'
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}

call plug#end()

"*****************************************************************************
"" Functions
"*****************************************************************************

function AdjustWindowHeight(min, max)
    exe min([line("$"), a:max]).'wincmd _'
endfunction

function CommandCabbr(abbr, exp)
    execute 'cabbr ' . a:abbr . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:exp . '" : "' . a:abbr . '"<CR>'
endfunction
command! -nargs=+ CommandCabbr call CommandCabbr(<f-args>)

"*****************************************************************************
"" Basic Setup
"*****************************************************************************

set number relativenumber
set path=.,,**

" Tabs
set tabstop=4
set shiftwidth=4
set expandtab

" Undo files
let &undodir = expand($XDG_CONFIG_HOME.'/nvim/undo')
set undofile

" Writes the content before :make
set autowrite

" Remove trailing spaces on save
augroup vimrc-trim-spaces-on-save
    au!
    au BufWritePre * :%s/\s\+$//e
augroup END

" Remember cursor position
augroup vimrc-remember-cursor-position
    au!
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Open quickfix on :make
augroup vimrc-open-quickfix-on-make
    au!
    au QuickFixCmdPost [^l]* nested cwindow
    au QuickFixCmdPost    l* nested lwindow
augroup END

" Fitting quickfix window height
au FileType qf call AdjustWindowHeight(3, 10)

"*****************************************************************************
"" Visual Settings
"*****************************************************************************

colorscheme gruvbox

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

"*****************************************************************************
"" Terminal
"*****************************************************************************

tnoremap <esc> <C-\><C-n>

au TermOpen * setlocal nonumber norelativenumber
au TermOpen * startinsert

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
    au Filetype go CommandCabbr tags GoDefStack
augroup END
