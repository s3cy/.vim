![vim-polyglot](https://i.imgur.com/9RxQK6k.png)

![build](https://github.com/sheerun/vim-polyglot/workflows/Vim%20Polyglot%20CI/badge.svg) [![Maintenance](https://img.shields.io/maintenance/yes/2020.svg?maxAge=2592000)]()

A collection of language packs for Vim.

> One to rule them all, one to find them, one to bring them all and in the darkness bind them.

- It **won't affect your startup time**, as scripts are loaded only on demand\*.
- It **installs and updates 120+ times faster** than the <!--Package Count-->27<!--/Package Count--> packages it consists of.
- It is more secure because scripts loaded for all extensions are generated by vim-polyglot (ftdetect).
- Solid syntax and indentation support (other features skipped). Only the best language packs.
- All unnecessary files are ignored (like enormous documentation from php support).
- Automatically detect indentation (includes performance-optimized version of [vim-sleuth](https://github.com/tpope/vim-sleuth))
- Each build is tested by automated vimrunner script on CI. See `spec` directory.

\*To be completely honest, optimized `ftdetect` script takes around `19ms` to load.

## Installation

1. Install [Pathogen](https://github.com/tpope/vim-pathogen), [Vundle](https://github.com/VundleVim/Vundle.vim), [NeoBundle](https://github.com/Shougo/neobundle.vim), or [Plug](https://github.com/junegunn/vim-plug) package manager for Vim.
2. Use this repository as submodule or package.

For example when using [Plug](https://github.com/junegunn/vim-plug):

```
Plug 'sheerun/vim-polyglot'
```

Optionally download one of the [releases](https://github.com/sheerun/vim-polyglot/releases) and unpack it directly under `~/.vim` directory.

You can also use Vim 8 built-in package manager:

```
mkdir -p ~/.vim/pack/default/start
git clone https://github.com/sheerun/vim-polyglot ~/.vim/pack/default/start/vim-polyglot
```

NOTE: Not all features of individual language packs are available. We strip them from functionality slowing vim startup (for example we ignore `plugins` folder that is loaded regardless of file type, instead we prefer `ftplugin` which is loaded lazily).

If you need full functionality of any plugin, please use it directly with your plugin manager.

## Language packs

<!--Language Packs-->
- [c/c++](https://github.com/vim-jp/vim-cpp)
- [cmake](https://github.com/pboettch/vim-cmake-syntax)
- [csv](https://github.com/chrisbra/csv.vim)
- [dockerfile](https://github.com/ekalinin/Dockerfile.vim)
- [fish](https://github.com/georgewitteman/vim-fish)
- [git](https://github.com/tpope/vim-git)
- [go](https://github.com/fatih/vim-go)
- [helm](https://github.com/towolf/vim-helm)
- [help](https://github.com/neovim/neovim/tree/master/runtime)
- [javascript](https://github.com/pangloss/vim-javascript)
- [json](https://github.com/elzr/vim-json)
- [log](https://github.com/MTDL9/vim-log-highlighting)
- [markdown](https://github.com/plasticboy/vim-markdown)
- [nginx](https://github.com/chr4/nginx.vim)
- [protobuf](https://github.com/uarun/vim-protobuf)
- [python-compiler](https://github.com/aliev/vim-compiler-python)
- [python-indent](https://github.com/Vimjas/vim-python-pep8-indent)
- [python](https://github.com/vim-python/python-syntax)
- [requirements](https://github.com/raimon49/requirements.txt.vim)
- [rust](https://github.com/rust-lang/rust.vim)
- [sh](https://github.com/arzg/vim-sh)
- [systemd](https://github.com/wgwoods/vim-systemd-syntax)
- [textile](https://github.com/timcharper/textile.vim)
- [toml](https://github.com/cespare/vim-toml)
- [typescript](https://github.com/HerringtonDarkholme/yats.vim)
- [xml](https://github.com/amadeus/vim-xml)
- [yaml](https://github.com/stephpy/vim-yaml)
<!--/Language Packs-->

## Updating

You can either wait for new patch release with updates or run `make` by yourself.

## Troubleshooting

Please make sure you have `syntax on` in your `.vimrc` (or use something like [sheerun/vimrc](https://github.com/sheerun/vimrc))

Individual language packs can be disabled by setting `g:polyglot_disabled` as follows:

```vim
let g:polyglot_disabled = ['css']
```

*Please declare this variable before polyglot is loaded (at the top of .vimrc)*

Please note that disabling a language won't make in your vim startup any faster / slower (only for specific this specific filetype). All plugins are loaded lazily, on demand.

Vim Polyglot tries to automatically detect indentation settings (just like vim-sleuth). If this feature is not working for you for some reason, please file an issue and disable it temporarily with:

```vim
let g:polyglot_disabled = ['autoindent']
```

## Contributing

Language packs are periodically updated using automated `scripts/build` script.

Feel free to add your language to `packages.yaml` + `heuristics.yaml`, and send pull-request. You can run `make test` to run rough tests. And `make dev` for easy development.

## License

See linked repositories for detailed license information. This repository is MIT-licensed.
