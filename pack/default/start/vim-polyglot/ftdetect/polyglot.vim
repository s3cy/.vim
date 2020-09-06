" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

" Disable all native vim ftdetect
if exists('g:polyglot_test')
  autocmd!
endif

let s:disabled_packages = {}

if exists('g:polyglot_disabled')
  for pkg in g:polyglot_disabled
    let s:disabled_packages[pkg] = 1
  endfor
endif

function! s:SetDefault(name, value)
  if !exists(a:name)
    let {a:name} = a:value
  endif
endfunction

call s:SetDefault('g:markdown_enable_spell_checking', 0)
call s:SetDefault('g:markdown_enable_input_abbreviations', 0)
call s:SetDefault('g:markdown_enable_mappings', 0)

" Enable jsx syntax by default
call s:SetDefault('g:jsx_ext_required', 0)

" Needed for sql highlighting
call s:SetDefault('g:javascript_sql_dialect', 'sql')

" Make csv loading faster
call s:SetDefault('g:csv_start', 1)
call s:SetDefault('g:csv_end', 2)

" Disable json concealing by default
call s:SetDefault('g:vim_json_syntax_conceal', 0)

call s:SetDefault('g:filetype_euphoria', 'elixir')

if !exists('g:python_highlight_all')
  call s:SetDefault('g:python_highlight_builtins', 1)
  call s:SetDefault('g:python_highlight_builtin_objs', 1)
  call s:SetDefault('g:python_highlight_builtin_types', 1)
  call s:SetDefault('g:python_highlight_builtin_funcs', 1)
  call s:SetDefault('g:python_highlight_builtin_funcs_kwarg', 1)
  call s:SetDefault('g:python_highlight_exceptions', 1)
  call s:SetDefault('g:python_highlight_string_formatting', 1)
  call s:SetDefault('g:python_highlight_string_format', 1)
  call s:SetDefault('g:python_highlight_string_templates', 1)
  call s:SetDefault('g:python_highlight_indent_errors', 1)
  call s:SetDefault('g:python_highlight_space_errors', 1)
  call s:SetDefault('g:python_highlight_doctests', 1)
  call s:SetDefault('g:python_highlight_func_calls', 1)
  call s:SetDefault('g:python_highlight_class_vars', 1)
  call s:SetDefault('g:python_highlight_operators', 1)
  call s:SetDefault('g:python_highlight_file_headers_as_comments', 1)
  call s:SetDefault('g:python_slow_sync', 1)
endif

" filetypes

if !has_key(s:disabled_packages, 'c/c++')
  au BufNewFile,BufRead *.c setf c
  au BufNewFile,BufRead *.cats setf c
  au BufNewFile,BufRead *.h setf c
  au BufNewFile,BufRead *.idc setf c
  au BufNewFile,BufRead *.c++ setf cpp
  au BufNewFile,BufRead *.cc setf cpp
  au BufNewFile,BufRead *.cp setf cpp
  au BufNewFile,BufRead *.cpp setf cpp
  au BufNewFile,BufRead *.cxx setf cpp
  au BufNewFile,BufRead *.h setf cpp
  au BufNewFile,BufRead *.h++ setf cpp
  au BufNewFile,BufRead *.hh setf cpp
  au BufNewFile,BufRead *.hpp setf cpp
  au BufNewFile,BufRead *.hxx setf cpp
  au BufNewFile,BufRead *.inc setf cpp
  au BufNewFile,BufRead *.inl setf cpp
  au BufNewFile,BufRead *.ipp setf cpp
  au BufNewFile,BufRead *.tcc setf cpp
  au BufNewFile,BufRead *.tpp setf cpp
endif

if !has_key(s:disabled_packages, 'cmake')
  au BufNewFile,BufRead *.cmake setf cmake
  au BufNewFile,BufRead *.cmake.in setf cmake
  au BufNewFile,BufRead CMakeLists.txt setf cmake
endif

if !has_key(s:disabled_packages, 'csv')
  au BufNewFile,BufRead *.csv setf csv
  au BufNewFile,BufRead *.tab setf csv
  au BufNewFile,BufRead *.tsv setf csv
endif

if !has_key(s:disabled_packages, 'dockerfile')
  au BufNewFile,BufRead *.Dockerfile setf Dockerfile
  au BufNewFile,BufRead *.dock setf Dockerfile
  au BufNewFile,BufRead *.dockerfile setf Dockerfile
  au BufNewFile,BufRead Dockerfile setf Dockerfile
  au BufNewFile,BufRead Dockerfile* setf Dockerfile
  au BufNewFile,BufRead dockerfile setf Dockerfile
  au BufNewFile,BufRead docker-compose*.yaml setf yaml.docker-compose
  au BufNewFile,BufRead docker-compose*.yml setf yaml.docker-compose
endif

if !has_key(s:disabled_packages, 'fish')
  au BufNewFile,BufRead *.fish setf fish
endif

if !has_key(s:disabled_packages, 'git')
  au BufNewFile,BufRead *.gitconfig setf gitconfig
  au BufNewFile,BufRead *.git/config setf gitconfig
  au BufNewFile,BufRead *.git/modules/**/config setf gitconfig
  au BufNewFile,BufRead */.config/git/config setf gitconfig
  au BufNewFile,BufRead {.,}gitconfig setf gitconfig
  au BufNewFile,BufRead {.,}gitmodules setf gitconfig
  au BufNewFile,BufRead git-rebase-todo setf gitrebase
  au BufNewFile,BufRead {.,}gitsendemail.* setf gitsendemail
  au BufNewFile,BufRead *.git/{,modules/**/,worktrees/*/}{COMMIT_EDIT,TAG_EDIT,MERGE_,}MSG setf gitcommit
endif

if !has_key(s:disabled_packages, 'go')
  au BufNewFile,BufRead *.go setf go
  au BufNewFile,BufRead go.mod setf gomod
  au BufNewFile,BufRead *.tmpl setf gohtmltmpl
endif

if !has_key(s:disabled_packages, 'javascript')
  au BufNewFile,BufRead *._js setf javascript
  au BufNewFile,BufRead *.bones setf javascript
  au BufNewFile,BufRead *.cjs setf javascript
  au BufNewFile,BufRead *.es setf javascript
  au BufNewFile,BufRead *.es6 setf javascript
  au BufNewFile,BufRead *.frag setf javascript
  au BufNewFile,BufRead *.gs setf javascript
  au BufNewFile,BufRead *.jake setf javascript
  au BufNewFile,BufRead *.js setf javascript
  au BufNewFile,BufRead *.jsb setf javascript
  au BufNewFile,BufRead *.jscad setf javascript
  au BufNewFile,BufRead *.jsfl setf javascript
  au BufNewFile,BufRead *.jsm setf javascript
  au BufNewFile,BufRead *.jss setf javascript
  au BufNewFile,BufRead *.mjs setf javascript
  au BufNewFile,BufRead *.njs setf javascript
  au BufNewFile,BufRead *.pac setf javascript
  au BufNewFile,BufRead *.sjs setf javascript
  au BufNewFile,BufRead *.ssjs setf javascript
  au BufNewFile,BufRead *.xsjs setf javascript
  au BufNewFile,BufRead *.xsjslib setf javascript
  au BufNewFile,BufRead Jakefile setf javascript
  au BufNewFile,BufRead *.flow setf flow
endif

if !has_key(s:disabled_packages, 'json')
  au BufNewFile,BufRead *.JSON-tmLanguage setf json
  au BufNewFile,BufRead *.avsc setf json
  au BufNewFile,BufRead *.geojson setf json
  au BufNewFile,BufRead *.gltf setf json
  au BufNewFile,BufRead *.har setf json
  au BufNewFile,BufRead *.ice setf json
  au BufNewFile,BufRead *.json setf json
  au BufNewFile,BufRead *.jsonl setf json
  au BufNewFile,BufRead *.jsonp setf json
  au BufNewFile,BufRead *.mcmeta setf json
  au BufNewFile,BufRead *.template setf json
  au BufNewFile,BufRead *.tfstate setf json
  au BufNewFile,BufRead *.tfstate.backup setf json
  au BufNewFile,BufRead *.topojson setf json
  au BufNewFile,BufRead *.webapp setf json
  au BufNewFile,BufRead *.webmanifest setf json
  au BufNewFile,BufRead *.yy setf json
  au BufNewFile,BufRead *.yyp setf json
  au BufNewFile,BufRead {.,}arcconfig setf json
  au BufNewFile,BufRead {.,}htmlhintrc setf json
  au BufNewFile,BufRead {.,}tern-config setf json
  au BufNewFile,BufRead {.,}tern-project setf json
  au BufNewFile,BufRead {.,}watchmanconfig setf json
  au BufNewFile,BufRead composer.lock setf json
  au BufNewFile,BufRead mcmod.info setf json
endif

if !has_key(s:disabled_packages, 'log')
  au BufNewFile,BufRead *.LOG setf log
  au BufNewFile,BufRead *.log setf log
  au BufNewFile,BufRead *_LOG setf log
  au BufNewFile,BufRead *_log setf log
endif

if !has_key(s:disabled_packages, 'markdown')
  au BufNewFile,BufRead *.markdown setf markdown
  au BufNewFile,BufRead *.md setf markdown
  au BufNewFile,BufRead *.mdown setf markdown
  au BufNewFile,BufRead *.mdwn setf markdown
  au BufNewFile,BufRead *.mkd setf markdown
  au BufNewFile,BufRead *.mkdn setf markdown
  au BufNewFile,BufRead *.mkdown setf markdown
  au BufNewFile,BufRead *.ronn setf markdown
  au BufNewFile,BufRead *.workbook setf markdown
  au BufNewFile,BufRead contents.lr setf markdown
endif

if !has_key(s:disabled_packages, 'nginx')
  au BufNewFile,BufRead *.nginx setf nginx
  au BufNewFile,BufRead *.nginxconf setf nginx
  au BufNewFile,BufRead *.vhost setf nginx
  au BufNewFile,BufRead */etc/nginx/* setf nginx
  au BufNewFile,BufRead */nginx/*.conf setf nginx
  au BufNewFile,BufRead */usr/local/nginx/conf/* setf nginx
  au BufNewFile,BufRead *nginx.conf setf nginx
  au BufNewFile,BufRead nginx*.conf setf nginx
  au BufNewFile,BufRead nginx.conf setf nginx
endif

if !has_key(s:disabled_packages, 'protobuf')
  au BufNewFile,BufRead *.proto setf proto
endif

if !has_key(s:disabled_packages, 'python')
  au BufNewFile,BufRead *.cgi setf python
  au BufNewFile,BufRead *.fcgi setf python
  au BufNewFile,BufRead *.gyp setf python
  au BufNewFile,BufRead *.gypi setf python
  au BufNewFile,BufRead *.lmi setf python
  au BufNewFile,BufRead *.py setf python
  au BufNewFile,BufRead *.py3 setf python
  au BufNewFile,BufRead *.pyde setf python
  au BufNewFile,BufRead *.pyi setf python
  au BufNewFile,BufRead *.pyp setf python
  au BufNewFile,BufRead *.pyt setf python
  au BufNewFile,BufRead *.pyw setf python
  au BufNewFile,BufRead *.rpy setf python
  au BufNewFile,BufRead *.smk setf python
  au BufNewFile,BufRead *.spec setf python
  au BufNewFile,BufRead *.tac setf python
  au BufNewFile,BufRead *.wsgi setf python
  au BufNewFile,BufRead *.xpy setf python
  au BufNewFile,BufRead {.,}gclient setf python
  au BufNewFile,BufRead DEPS setf python
  au BufNewFile,BufRead SConscript setf python
  au BufNewFile,BufRead SConstruct setf python
  au BufNewFile,BufRead Snakefile setf python
  au BufNewFile,BufRead wscript setf python
endif

if !has_key(s:disabled_packages, 'python-indent')
endif

if !has_key(s:disabled_packages, 'python-compiler')
endif

if !has_key(s:disabled_packages, 'requirements')
  au BufNewFile,BufRead *.pip setf requirements
  au BufNewFile,BufRead *require.{txt,in} setf requirements
  au BufNewFile,BufRead *requirements.{txt,in} setf requirements
  au BufNewFile,BufRead constraints.{txt,in} setf requirements
endif

if !has_key(s:disabled_packages, 'rust')
  au BufNewFile,BufRead *.rs setf rust
  au BufNewFile,BufRead *.rs.in setf rust
endif

if !has_key(s:disabled_packages, 'sh')
  au BufNewFile,BufRead *.bash setf sh
  au BufNewFile,BufRead *.bats setf sh
  au BufNewFile,BufRead *.cgi setf sh
  au BufNewFile,BufRead *.command setf sh
  au BufNewFile,BufRead *.env setf sh
  au BufNewFile,BufRead *.fcgi setf sh
  au BufNewFile,BufRead *.ksh setf sh
  au BufNewFile,BufRead *.sh setf sh
  au BufNewFile,BufRead *.sh.in setf sh
  au BufNewFile,BufRead *.tmux setf sh
  au BufNewFile,BufRead *.tool setf sh
  au BufNewFile,BufRead {.,}bash_aliases setf sh
  au BufNewFile,BufRead {.,}bash_history setf sh
  au BufNewFile,BufRead {.,}bash_logout setf sh
  au BufNewFile,BufRead {.,}bash_profile setf sh
  au BufNewFile,BufRead {.,}bashrc setf sh
  au BufNewFile,BufRead {.,}cshrc setf sh
  au BufNewFile,BufRead {.,}env setf sh
  au BufNewFile,BufRead {.,}env.example setf sh
  au BufNewFile,BufRead {.,}flaskenv setf sh
  au BufNewFile,BufRead {.,}login setf sh
  au BufNewFile,BufRead {.,}profile setf sh
  au BufNewFile,BufRead 9fs setf sh
  au BufNewFile,BufRead PKGBUILD setf sh
  au BufNewFile,BufRead bash_aliases setf sh
  au BufNewFile,BufRead bash_logout setf sh
  au BufNewFile,BufRead bash_profile setf sh
  au BufNewFile,BufRead bashrc setf sh
  au BufNewFile,BufRead cshrc setf sh
  au BufNewFile,BufRead gradlew setf sh
  au BufNewFile,BufRead login setf sh
  au BufNewFile,BufRead man setf sh
  au BufNewFile,BufRead profile setf sh
  au BufNewFile,BufRead *.zsh setf zsh
  au BufNewFile,BufRead {.,}zlogin setf zsh
  au BufNewFile,BufRead {.,}zlogout setf zsh
  au BufNewFile,BufRead {.,}zprofile setf zsh
  au BufNewFile,BufRead {.,}zshenv setf zsh
  au BufNewFile,BufRead {.,}zshrc setf zsh
endif

if !has_key(s:disabled_packages, 'systemd')
  au BufNewFile,BufRead *.automount setf systemd
  au BufNewFile,BufRead *.mount setf systemd
  au BufNewFile,BufRead *.path setf systemd
  au BufNewFile,BufRead *.service setf systemd
  au BufNewFile,BufRead *.socket setf systemd
  au BufNewFile,BufRead *.swap setf systemd
  au BufNewFile,BufRead *.target setf systemd
  au BufNewFile,BufRead *.timer setf systemd
endif

if !has_key(s:disabled_packages, 'textile')
  au BufNewFile,BufRead *.textile setf textile
endif

if !has_key(s:disabled_packages, 'toml')
  au BufNewFile,BufRead *.toml setf toml
  au BufNewFile,BufRead */.cargo/config setf toml
  au BufNewFile,BufRead */.cargo/credentials setf toml
  au BufNewFile,BufRead Cargo.lock setf toml
  au BufNewFile,BufRead Gopkg.lock setf toml
  au BufNewFile,BufRead Pipfile setf toml
  au BufNewFile,BufRead poetry.lock setf toml
endif

if !has_key(s:disabled_packages, 'typescript')
  au BufNewFile,BufRead *.ts setf typescript
  au BufNewFile,BufRead *.tsx setf typescriptreact
endif

if !has_key(s:disabled_packages, 'xml')
  au BufNewFile,BufRead *.adml setf xml
  au BufNewFile,BufRead *.admx setf xml
  au BufNewFile,BufRead *.ant setf xml
  au BufNewFile,BufRead *.axml setf xml
  au BufNewFile,BufRead *.builds setf xml
  au BufNewFile,BufRead *.ccproj setf xml
  au BufNewFile,BufRead *.ccxml setf xml
  au BufNewFile,BufRead *.cdxml setf xml
  au BufNewFile,BufRead *.clixml setf xml
  au BufNewFile,BufRead *.cproject setf xml
  au BufNewFile,BufRead *.cscfg setf xml
  au BufNewFile,BufRead *.csdef setf xml
  au BufNewFile,BufRead *.csl setf xml
  au BufNewFile,BufRead *.csproj setf xml
  au BufNewFile,BufRead *.ct setf xml
  au BufNewFile,BufRead *.depproj setf xml
  au BufNewFile,BufRead *.dita setf xml
  au BufNewFile,BufRead *.ditamap setf xml
  au BufNewFile,BufRead *.ditaval setf xml
  au BufNewFile,BufRead *.dll.config setf xml
  au BufNewFile,BufRead *.dotsettings setf xml
  au BufNewFile,BufRead *.filters setf xml
  au BufNewFile,BufRead *.fsproj setf xml
  au BufNewFile,BufRead *.fxml setf xml
  au BufNewFile,BufRead *.glade setf xml
  au BufNewFile,BufRead *.gml setf xml
  au BufNewFile,BufRead *.gmx setf xml
  au BufNewFile,BufRead *.grxml setf xml
  au BufNewFile,BufRead *.gst setf xml
  au BufNewFile,BufRead *.iml setf xml
  au BufNewFile,BufRead *.ivy setf xml
  au BufNewFile,BufRead *.jelly setf xml
  au BufNewFile,BufRead *.jsproj setf xml
  au BufNewFile,BufRead *.kml setf xml
  au BufNewFile,BufRead *.launch setf xml
  au BufNewFile,BufRead *.mdpolicy setf xml
  au BufNewFile,BufRead *.mjml setf xml
  au BufNewFile,BufRead *.mm setf xml
  au BufNewFile,BufRead *.mod setf xml
  au BufNewFile,BufRead *.mxml setf xml
  au BufNewFile,BufRead *.natvis setf xml
  au BufNewFile,BufRead *.ncl setf xml
  au BufNewFile,BufRead *.ndproj setf xml
  au BufNewFile,BufRead *.nproj setf xml
  au BufNewFile,BufRead *.nuspec setf xml
  au BufNewFile,BufRead *.odd setf xml
  au BufNewFile,BufRead *.osm setf xml
  au BufNewFile,BufRead *.pkgproj setf xml
  au BufNewFile,BufRead *.pluginspec setf xml
  au BufNewFile,BufRead *.proj setf xml
  au BufNewFile,BufRead *.props setf xml
  au BufNewFile,BufRead *.ps1xml setf xml
  au BufNewFile,BufRead *.psc1 setf xml
  au BufNewFile,BufRead *.pt setf xml
  au BufNewFile,BufRead *.rdf setf xml
  au BufNewFile,BufRead *.resx setf xml
  au BufNewFile,BufRead *.rss setf xml
  au BufNewFile,BufRead *.sch setf xml
  au BufNewFile,BufRead *.scxml setf xml
  au BufNewFile,BufRead *.sfproj setf xml
  au BufNewFile,BufRead *.shproj setf xml
  au BufNewFile,BufRead *.srdf setf xml
  au BufNewFile,BufRead *.storyboard setf xml
  au BufNewFile,BufRead *.sublime-snippet setf xml
  au BufNewFile,BufRead *.targets setf xml
  au BufNewFile,BufRead *.tml setf xml
  au BufNewFile,BufRead *.ui setf xml
  au BufNewFile,BufRead *.urdf setf xml
  au BufNewFile,BufRead *.ux setf xml
  au BufNewFile,BufRead *.vbproj setf xml
  au BufNewFile,BufRead *.vcxproj setf xml
  au BufNewFile,BufRead *.vsixmanifest setf xml
  au BufNewFile,BufRead *.vssettings setf xml
  au BufNewFile,BufRead *.vstemplate setf xml
  au BufNewFile,BufRead *.vxml setf xml
  au BufNewFile,BufRead *.wixproj setf xml
  au BufNewFile,BufRead *.workflow setf xml
  au BufNewFile,BufRead *.wsdl setf xml
  au BufNewFile,BufRead *.wsf setf xml
  au BufNewFile,BufRead *.wxi setf xml
  au BufNewFile,BufRead *.wxl setf xml
  au BufNewFile,BufRead *.wxs setf xml
  au BufNewFile,BufRead *.x3d setf xml
  au BufNewFile,BufRead *.xacro setf xml
  au BufNewFile,BufRead *.xaml setf xml
  au BufNewFile,BufRead *.xib setf xml
  au BufNewFile,BufRead *.xlf setf xml
  au BufNewFile,BufRead *.xliff setf xml
  au BufNewFile,BufRead *.xmi setf xml
  au BufNewFile,BufRead *.xml setf xml
  au BufNewFile,BufRead *.xml.dist setf xml
  au BufNewFile,BufRead *.xproj setf xml
  au BufNewFile,BufRead *.xsd setf xml
  au BufNewFile,BufRead *.xspec setf xml
  au BufNewFile,BufRead *.xul setf xml
  au BufNewFile,BufRead *.zcml setf xml
  au BufNewFile,BufRead {.,}classpath setf xml
  au BufNewFile,BufRead {.,}cproject setf xml
  au BufNewFile,BufRead {.,}project setf xml
  au BufNewFile,BufRead App.config setf xml
  au BufNewFile,BufRead NuGet.config setf xml
  au BufNewFile,BufRead Settings.StyleCop setf xml
  au BufNewFile,BufRead Web.Debug.config setf xml
  au BufNewFile,BufRead Web.Release.config setf xml
  au BufNewFile,BufRead Web.config setf xml
  au BufNewFile,BufRead packages.config setf xml
endif

if !has_key(s:disabled_packages, 'yaml')
  au BufNewFile,BufRead *.mir setf yaml
  au BufNewFile,BufRead *.reek setf yaml
  au BufNewFile,BufRead *.rviz setf yaml
  au BufNewFile,BufRead *.sublime-syntax setf yaml
  au BufNewFile,BufRead *.syntax setf yaml
  au BufNewFile,BufRead *.yaml setf yaml
  au BufNewFile,BufRead *.yaml-tmlanguage setf yaml
  au BufNewFile,BufRead *.yaml.sed setf yaml
  au BufNewFile,BufRead *.yml setf yaml
  au BufNewFile,BufRead *.yml.mysql setf yaml
  au BufNewFile,BufRead {.,}clang-format setf yaml
  au BufNewFile,BufRead {.,}clang-tidy setf yaml
  au BufNewFile,BufRead {.,}gemrc setf yaml
  au BufNewFile,BufRead fish_history setf yaml
  au BufNewFile,BufRead fish_read_history setf yaml
  au BufNewFile,BufRead glide.lock setf yaml
  au BufNewFile,BufRead yarn.lock setf yaml
endif

if !has_key(s:disabled_packages, 'helm')
  au BufNewFile,BufRead */templates/*.tpl setf helm
  au BufNewFile,BufRead */templates/*.yaml setf helm
endif

if !has_key(s:disabled_packages, 'help')
  au BufNewFile,BufRead $VIMRUNTIME/doc/*.txt setf help
endif


" end filetypes

au BufNewFile,BufRead,StdinReadPost * 
  \ if !did_filetype() && expand("<amatch>") !~ g:ft_ignore_pat 
  \ | call polyglot#Heuristics() | endif

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save
