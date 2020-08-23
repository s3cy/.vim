#!/bin/bash

PACKS=(
	"justinmk/vim-dirvish"
	"ludovicchabant/vim-gutentags"
	"niklaas/lightline-gitdiff"
	"prabirshrestha/vim-lsp"
	"roxma/vim-paste-easy"
	"s3cy/vim-gruvbox256"
	"sheerun/vim-polyglot"
	"takac/vim-hardtime"
	"tpope/vim-abolish"
	"tpope/vim-commentary"
	"tpope/vim-dispatch"
	"tpope/vim-fugitive"
	"tpope/vim-repeat"
	"tpope/vim-sensible"
	"tpope/vim-surround"
	"tpope/vim-unimpaired"
)

PACK_PATH="pack/default/start"
GIT_REPO_ADDR="https://github.com"

check_if_exist() {
	[ -d "$PACK_PATH/$1" ]
}

git_subtree() {
	git subtree $1 --prefix "$PACK_PATH/$2" "$GIT_REPO_ADDR/$3" master --squash
}

download() {
	echo "downloading $2"
	git_subtree "add" $@
}

update() {
	echo "updating $2"
	git_subtree "pull" $@
}

cd "$(dirname "$0")"
mkdir -p "$PACK_PATH"

for pack in ${PACKS[@]}; do
	IFS='/' read -ra addr <<< "$pack"
	name=${addr[-1]}

	if ! check_if_exist "$name"; then
		download "$name" "$pack"
	else
		update "$name" "$pack"
	fi
done

