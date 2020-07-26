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

Plug 'fatih/vim-go'
Plug 'flazz/vim-colorschemes'
Plug 'justinmk/vim-dirvish'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mhinz/vim-signify'
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
set updatetime=100

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

function! StatusLineAsyncRun()
    return g:asyncrun_status ==# 'running' ? '[asyncrun]' : ''
endfunction

function! StatusLineFileFormat()
    return &ff ==# 'unix' ? '' : ('[' . &ff . ']')
endfunction

function! StatusLineFileEncoding()
    return &fenc ==# 'utf-8' ? '' : ('[' . (strlen(&fenc) ? &fenc : 'none') . ']')
endfunction

function! StatusLine(mode) abort
    let l:line = ''

    if a:mode ==# 'active'
        let l:line .= '%1*'
        let l:line .= ' %f%r'
        if &ro ==# ''
            let l:line .= '%m'
        endif
        let l:line .= ' '
        let l:line .= '%2*'
        let l:line .= ' '
        let l:line .= '%{sy#repo#get_stats_decorated()}'
        let l:line .= '%{StatusLineAsyncRun()}'
        let l:line .= "%{gutentags#statusline('[', ']')}"
        let l:line .= '%='
        let l:line .= '%{StatusLineFileFormat()}'
        let l:line .= '%{StatusLineFileEncoding()}'
        let l:line .= ' '
        let l:line .= '%1*'
        let l:line .= ' %y %P '
    else
        let l:line .= '%3*'
        let l:line .= ' %f%=%P '
    endif

    return l:line
endfunction

hi User1 ctermbg=239   ctermfg=245  guibg=#504945   guifg=#928374
hi User2 ctermbg=237   ctermfg=243  guibg=#3c3836   guifg=#7c6f64
hi User3 ctermbg=235 ctermfg=245   guibg=#282828 guifg=#928374

set statusline=%!StatusLine('active')
augroup vimrc-statusline
    au!
    au WinEnter * setl statusline=%!StatusLine('active')
    au WinLeave * setl statusline=%!StatusLine('inactive')
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
