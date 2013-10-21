#!/usr/bin/env bash

## Link dictionay and files
ln -s `pwd` ~/.vim
ln -s `pwd`/vimrc ~/.vimrc 

## Install Neobundle
mkdir ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

## Install all plugins
vim +NeoBundleInstall +qall
