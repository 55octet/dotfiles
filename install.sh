#!/usr/bin/env bash

if [[ $EUID != 0 ]]; then
    xargs_param='-0'
    exe_dir=$(realpath $(dirname $0))
    
    if ! pushd config > /dev/null; then
        echo "config directory does not exist, exiting"
        exit 1
    fi
    
    git submodule update --init --recursive
    
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


    if [[ $(uname) == Linux ]]; then
        xargs_param+='r'
    fi

    find $HOME/.vim -type d -name '.git' -print0 | xargs ${xargs_param} rm -rv
    ln -fsv $HOME/.vim/vim-pathogen/autoload $HOME/.vim/autoload

    sudo "$0"
else
    cp -fv profile.d/custom.sh /etc/profile.d/custom.sh
fi

exit 0
