function! TestFiletype(filetype)
  try
    enew
    exec 'set ft=' . a:filetype
  catch
    echo 'Error loading filetype ' . a:filetype  . ':'
    echo v:exception
    echo v:throwpoint
    exec ':cq!'
  endtry
endfunction

call TestFiletype('cpp')
call TestFiletype('cmake')
call TestFiletype('csv')
call TestFiletype('Dockerfile')
call TestFiletype('yaml.docker-compose')
call TestFiletype('fish')
call TestFiletype('gitconfig')
call TestFiletype('gitrebase')
call TestFiletype('gitsendemail')
call TestFiletype('gitcommit')
call TestFiletype('go')
call TestFiletype('gomod')
call TestFiletype('gohtmltmpl')
call TestFiletype('javascript')
call TestFiletype('flow')
call TestFiletype('json')
call TestFiletype('log')
call TestFiletype('markdown')
call TestFiletype('nginx')
call TestFiletype('proto')
call TestFiletype('python')
call TestFiletype('requirements')
call TestFiletype('rust')
call TestFiletype('sh')
call TestFiletype('zsh')
call TestFiletype('systemd')
call TestFiletype('textile')
call TestFiletype('toml')
call TestFiletype('typescript')
call TestFiletype('typescriptreact')
call TestFiletype('xml')
call TestFiletype('yaml')
call TestFiletype('helm')
call TestFiletype('help')
