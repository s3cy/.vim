let s:globs = {
  \ 'Dockerfile': '*.dockerfile,*.dock,*.Dockerfile,Dockerfile,dockerfile,Dockerfile*',
  \ 'cmake': '*.cmake,*.cmake.in,CMakeLists.txt',
  \ 'cpp': '*.cpp,*.c++,*.cc,*.cp,*.cxx,*.h,*.h++,*.hh,*.hpp,*.hxx,*.inc,*.inl,*.ipp,*.tcc,*.tpp,*.moc,*.tlh',
  \ 'csv': '*.csv,*.tsv,*.tab',
  \ 'fish': '*.fish',
  \ 'flow': '*.flow',
  \ 'gitcommit': 'COMMIT_EDITMSG,MERGE_MSG,TAG_EDITMSG',
  \ 'gitconfig': '*.gitconfig',
  \ 'gitrebase': 'git-rebase-todo',
  \ 'gitsendemail': '',
  \ 'go': '*.go',
  \ 'gohtmltmpl': '*.tmpl',
  \ 'gomod': 'go.mod',
  \ 'helm': '',
  \ 'help': '',
  \ 'javascript': '*.js,*._js,*.bones,*.cjs,*.es,*.es6,*.frag,*.gs,*.jake,*.jsb,*.jscad,*.jsfl,*.jsm,*.jss,*.mjs,*.njs,*.pac,*.sjs,*.ssjs,*.xsjs,*.xsjslib,Jakefile',
  \ 'json': '*.json,*.avsc,*.geojson,*.gltf,*.har,*.ice,*.JSON-tmLanguage,*.jsonl,*.mcmeta,*.tfstate,*.tfstate.backup,*.topojson,*.webapp,*.webmanifest,*.yy,*.yyp,*.jsonp,*.template,composer.lock,mcmod.info',
  \ 'log': '*.log,*.LOG,*_log,*_LOG',
  \ 'markdown': '*.md,*.markdown,*.mdown,*.mdwn,*.mkd,*.mkdn,*.mkdown,*.ronn,*.workbook,contents.lr',
  \ 'nginx': '*.nginx,*.nginxconf,*.vhost,nginx.conf,nginx*.conf,*nginx.conf',
  \ 'proto': '*.proto',
  \ 'python': '*.py,*.cgi,*.fcgi,*.gyp,*.gypi,*.lmi,*.py3,*.pyde,*.pyi,*.pyp,*.pyt,*.pyw,*.rpy,*.smk,*.spec,*.tac,*.wsgi,*.xpy,DEPS,SConscript,SConstruct,Snakefile,wscript',
  \ 'requirements': '*.pip,*requirements.{txt,in},*require.{txt,in},constraints.{txt,in}',
  \ 'rust': '*.rs,*.rs.in',
  \ 'sh': '*.sh,*.bash,*.bats,*.cgi,*.command,*.env,*.fcgi,*.ksh,*.sh.in,*.tmux,*.tool,9fs,PKGBUILD,bash_aliases,bash_logout,bash_profile,bashrc,cshrc,gradlew,login,man,profile',
  \ 'systemd': '*.automount,*.mount,*.path,*.service,*.socket,*.swap,*.target,*.timer',
  \ 'textile': '*.textile',
  \ 'toml': '*.toml,Cargo.lock,Gopkg.lock,poetry.lock,Pipfile',
  \ 'typescript': '*.ts',
  \ 'typescriptreact': '*.tsx',
  \ 'xml': '*.xml,*.adml,*.admx,*.ant,*.axml,*.builds,*.ccproj,*.ccxml,*.clixml,*.cproject,*.cscfg,*.csdef,*.csl,*.csproj,*.ct,*.depproj,*.dita,*.ditamap,*.ditaval,*.dll.config,*.dotsettings,*.filters,*.fsproj,*.fxml,*.glade,*.gml,*.gmx,*.grxml,*.gst,*.iml,*.ivy,*.jelly,*.jsproj,*.kml,*.launch,*.mdpolicy,*.mjml,*.mm,*.mod,*.mxml,*.natvis,*.ncl,*.ndproj,*.nproj,*.nuspec,*.odd,*.osm,*.pkgproj,*.pluginspec,*.proj,*.props,*.ps1xml,*.psc1,*.pt,*.rdf,*.resx,*.rss,*.sch,*.scxml,*.sfproj,*.shproj,*.srdf,*.storyboard,*.sublime-snippet,*.targets,*.tml,*.ui,*.urdf,*.ux,*.vbproj,*.vcxproj,*.vsixmanifest,*.vssettings,*.vstemplate,*.vxml,*.wixproj,*.workflow,*.wsdl,*.wsf,*.wxi,*.wxl,*.wxs,*.x3d,*.xacro,*.xaml,*.xib,*.xlf,*.xliff,*.xmi,*.xml.dist,*.xproj,*.xsd,*.xspec,*.xul,*.zcml,*.cdxml,App.config,NuGet.config,Settings.StyleCop,Web.Debug.config,Web.Release.config,Web.config,packages.config',
  \ 'yaml': '*.yml,*.mir,*.reek,*.rviz,*.sublime-syntax,*.syntax,*.yaml,*.yaml-tmlanguage,*.yaml.sed,*.yml.mysql,glide.lock,yarn.lock,fish_history,fish_read_history',
  \ 'yaml.docker-compose': 'docker-compose*.yaml,docker-compose*.yml',
  \ 'zsh': '*.zsh',
  \}

func! sleuth#GlobForFiletype(type)
  return get(s:globs, a:type, '')
endfunc