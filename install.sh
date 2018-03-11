#!/usr/bin/env bash

exe_dir=$(realpath $(dirname $0))

if ! pushd config > /dev/null; then
    echo "config directory does not exist, exiting"
    exit 1
fi

git submodule update --init

echo "Installed configuration files"

shopt -s nullglob
files=(*)

for file in "${files[@]}"; do
    cp -v ${file} $HOME/.${file}
done

if ! popd > /dev/null; then
    echo "Cannot switch back to original repo home, exiting"
    exit 1
fi

echo "Installing vim configuration"

if [ ! -e $HOME/.vim ]; then
    mkdir $HOME/.vim
fi

cp -rv vim/* $HOME/.vim
find $HOME/.vim -type d -name '.git' -print | xargs rm -rv
ln -fsv $HOME/.vim/vim-pathogen/autoload $HOME/.vim/autoload

exit 0
