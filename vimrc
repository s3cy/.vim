"********************************************************************************
" Portable
"********************************************************************************

set nocompatible
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
let s:portable = expand('<sfile>:p:h')
let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)
let &packpath = &runtimepath

"********************************************************************************
" Post Install
"********************************************************************************

let s:bin_dir = expand(s:portable . '/bin')
if !isdirectory(s:bin_dir)
	call mkdir(s:bin_dir, '', 0700)
endif

let s:cache_dir = expand(s:portable . '/.cache')
let s:undo_dir = expand(s:cache_dir . '/undo')
let s:tags_dir = expand(s:cache_dir . '/tags')
if !isdirectory(s:cache_dir)
	call mkdir(s:undo_dir, 'p', 0700)
	call mkdir(s:tags_dir, 'p', 0700)
	silent exe '!bash ' . expand(s:portable . '/post_install.sh')
	silent! helptags ALL
endif

"********************************************************************************
" Basic Setup
"********************************************************************************

set hlsearch
set showcmd
set nowrap
set number relativenumber
set tabstop=4
set shiftwidth=4
set path=.,,**
set shortmess-=S
set matchpairs+=<:>
set cscopequickfix=g-,s-,c-,f-,i-,t-,d-,e-,a-

let g:go_highlight_trailing_whitespace_error = 0

" Bin directory for all related executables
if stridx($PATH, s:bin_dir) < 0
	let $PATH .= ':' . s:bin_dir
endif

" Undo files
let &undodir = s:undo_dir
set undofile

" Viminfo file
let &viminfofile = expand(s:cache_dir . '/viminfo')

" Hardtime
let g:hardtime_default_on = 1
let g:list_of_normal_keys = ["h", "j", "k", "l"]
let g:list_of_visual_keys = ["h", "j", "k", "l"]
let g:hardtime_timeout = 200

" Dirvish
let g:loaded_netrwPlugin = 1 " disable netrw
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>

" Dispatch
let g:dispatch_no_maps = 1

" Gutentags
let g:gutentags_file_list_command = 'git ls-files'
let g:gutentags_modules = []
if executable('ctags')
	let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope')
	let g:gutentags_modules += ['gtags_cscope']
endif
let g:gutentags_cache_dir = s:tags_dir

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

func! Tapi_TerminalEdit(bid, arglist) " invoked from a vim terminal buffer. See `:h term_setapi`
	let l:name = (type(a:arglist) == v:t_string) ? a:arglist : a:arglist[0]
	silent exe 'drop ' . fnameescape(name)
	return ''
endfunc

" Lightline gitdiff
func! LightlineGitdiffFormat(diff_dict) abort
	let l:indicators = { 'A': '+', 'D': '-', 'M': '~' }
	let l:Formatter = { key, val -> has_key(a:diff_dict, key) ?
				\ val . a:diff_dict[key] : '' }
	let l:res = join(values(filter(map(l:indicators, l:Formatter),
				\ { key, val -> val !=# '' })), ',')
	return l:res !=# '' ? '[' . l:res . ']' : ''
endfunc

func! LightlineGitdiffGet() abort
	return LightlineGitdiffFormat(get(g:lightline#gitdiff#cache, bufnr('%'), {}))
endfunc

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

" File type related
augroup vimrc-filetype
	au!
	au FileType c,cpp setlocal commentstring=//\ %s
	au FileType qf setlocal wrap
augroup END

" Strip trailing whitespaces
augroup vimrc-strip-trailing-whitespaces
	au!

	func! StripTrailingWhitespaces()
		let l:currentline = line(".")
		let l:currentcol = col(".")
		%s/\s\+$//e
		call cursor(l:currentline, l:currentcol) " restore position
	endfunc

	au BufWritePre * :call StripTrailingWhitespaces()
augroup END

"*****************************************************************************
" Visual Settings
"*****************************************************************************

" Color
if &term ==# 'xterm'
	" Xshell simulated xterm only supports 256 colors
	set t_Co=256
else
	" Alacritty true color support
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	set termguicolors
endif
colorscheme gruvbox256
set background=dark
let g:gruvbox_italics = 0
let g:gruvbox_plugin_hi_groups = 1

" Statusline
func! ActiveStatusline() abort
	let l:line = ''
	if &buftype ==# 'terminal'
		let l:line .= '%F%=%P'
		return l:line
	endif
	let l:line .= '%F %r'
	if &ro ==# ''
		let l:line .= '%m'
	endif
	let l:line .= '%#StatusLineNC#'
	let l:line .= ' '
	let l:line .= '%{LightlineGitdiffGet()}'
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

func! InactiveStatusline() abort
	let l:line = ''
	let l:line .= '%F%=%P'
	return l:line
endfunc

set statusline=%!ActiveStatusline()
augroup vimrc-statusline
	au!
	au WinEnter * setlocal statusline=%!ActiveStatusline()
	au WinLeave * setlocal statusline=%!InactiveStatusline()
	au User GutentagsUpdated setlocal statusline=%!ActiveStatusline()
	au User lsp_server_exit setlocal statusline=%!ActiveStatusline()
augroup END

" Tabline
func! Tabline()
	let l:line = ''
	for i in range(tabpagenr('$'))
		let l:tab = i + 1
		let l:winnr = tabpagewinnr(l:tab)
		let l:buflist = tabpagebuflist(l:tab)
		let l:bufnr = l:buflist[winnr - 1]
		let l:bufname = bufname(l:bufnr)
		let l:bufmodified = getbufvar(l:bufnr, "&mod")

		let l:line .= '%' . l:tab . 'T'
		let l:line .= (l:tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
		let l:line .= ' ' . l:tab . '|'
		if len(l:buflist) == 1
			let l:line .= (l:bufname !=# '' ? fnamemodify(l:bufname, ':t') : 'No Name')
		else
			let l:line .= len(l:buflist) . '..'
		endif
	endfor

	return l:line
endfunc
set tabline=%!Tabline()

"*****************************************************************************
" Key Bindings
"*****************************************************************************

" `Alt-w` is the universal window swiching key for both regular buffers and
" terminal buffers.
nnoremap <Esc>w <C-w>
nnoremap <Esc>w<Esc>b <C-w>b
nnoremap <Esc>w<Esc>c <C-w>c
nnoremap <Esc>w<Esc>d <C-w>d
nnoremap <Esc>w<Esc>f <C-w>f
nmap <Esc>w<Esc>g <C-w>g
nnoremap <Esc>w<Esc>h <C-w>h
nnoremap <Esc>w<Esc>i <C-w>i
nnoremap <Esc>w<Esc>j <C-w>j
nnoremap <Esc>w<Esc>k <C-w>k
nnoremap <Esc>w<Esc>l <C-w>l
nnoremap <Esc>w<Esc>n <C-w>n
nnoremap <Esc>w<Esc>o <C-w>o
nnoremap <Esc>w<Esc>p <C-w>p
nnoremap <Esc>w<Esc>q <C-w>q
nnoremap <Esc>w<Esc>r <C-w>r
nnoremap <Esc>w<Esc>s <C-w>s
nnoremap <Esc>w<Esc>t <C-w>t
nnoremap <Esc>w<Esc>v <C-w>v
nnoremap <Esc>w<Esc>w <C-w>w
nnoremap <Esc>w<Esc>x <C-w>x
nnoremap <Esc>w<Esc>z <C-w>z
nnoremap <Esc>w<Esc>] <C-w>]
nnoremap <Esc>w<Esc>^ <C-w>^
nnoremap <Esc>w<Esc>_ <C-w>_

set termwinkey=<C-_>
tnoremap <Esc>w <C-_>
tnoremap <Esc>w<Esc>b <C-_>b
tnoremap <Esc>w<Esc>c <C-_>c
tnoremap <Esc>w<Esc>d <C-_>d
tnoremap <Esc>w<Esc>f <C-_>f
tmap <Esc>w<Esc>g <C-_>g
tnoremap <Esc>w<Esc>h <C-_>h
tnoremap <Esc>w<Esc>i <C-_>i
tnoremap <Esc>w<Esc>j <C-_>j
tnoremap <Esc>w<Esc>k <C-_>k
tnoremap <Esc>w<Esc>l <C-_>l
tnoremap <Esc>w<Esc>n <C-_>n
tnoremap <Esc>w<Esc>o <C-_>o
tnoremap <Esc>w<Esc>p <C-_>p
tnoremap <Esc>w<Esc>q <C-_>q
tnoremap <Esc>w<Esc>r <C-_>r
tnoremap <Esc>w<Esc>s <C-_>s
tnoremap <Esc>w<Esc>t <C-_>t
tnoremap <Esc>w<Esc>v <C-_>v
tnoremap <Esc>w<Esc>w <C-_>w
tnoremap <Esc>w<Esc>x <C-_>x
tnoremap <Esc>w<Esc>z <C-_>z
tnoremap <Esc>w<Esc>] <C-_>]
tnoremap <Esc>w<Esc>^ <C-_>^
tnoremap <Esc>w<Esc>_ <C-_>_

" Shell-style command moves
cnoremap <C-a> <HOME>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
cnoremap <C-n> <DOWN>
cnoremap <C-p> <UP>

" Faster window switching
nnoremap <Esc>j <C-w>j
nnoremap <Esc>k <C-w>k
nnoremap <Esc>l <C-w>l
nnoremap <Esc>h <C-w>h
nnoremap <Esc>q <C-w>q
nnoremap <Esc>s <C-w>s
nnoremap <Esc>v <C-w>v
tnoremap <Esc>j <C-_>j
tnoremap <Esc>k <C-_>k
tnoremap <Esc>l <C-_>l
tnoremap <Esc>q <C-_>q
tnoremap <Esc>h <C-_>h
tnoremap <Esc>s <C-_>s
tnoremap <Esc>v <C-_>v

" Faster tab switching
nnoremap <Esc>t :tabnext<CR>
nnoremap <Esc>T :tabprevious<CR>
tnoremap <Esc>t <C-_>:tabnext<CR>
tnoremap <Esc>T <C-_>:tabprevious<CR>

" Double tab esc to exit terminal insert mode
tnoremap <Esc><Esc> <C-\><C-n>

" `Q` to edit the default register; `"aQ` to edit register 'a'.
" TIPS: macros are stored in registers.
nnoremap Q :<C-u><C-r><C-r>='let @' . v:register .
			\ ' = ' . string(getreg(v:register))<CR><C-f><LEFT>

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
" Lsp
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

	if executable('clangd')
		au User lsp_setup call lsp#register_server({
					\ 'name': 'clangd',
					\ 'cmd': { server_info->['clangd', '-background-index'] },
					\ 'allowlist': ['c', 'cpp'] })
		let s:lsp_allowlist += ['c', 'cpp']
	endif

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

	au FileType * call ConfirmToEnableLsp()
augroup END

