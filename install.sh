#!/usr/bin/env bash

## Link dictionay and files
ln -s `pwd` ~/.vim
ln -s `pwd`/vimrc ~/.vimrc 

## Install Neobundle
mkdir ~/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

## Install all plugins
vim +NeoBundleInstall +qall

## CCtree setting
mkdir -p ~/.vim/bundle/CCTree/ftplugin/c
mkdir -p ~/.vim/bundle/CCTree/ftplugin/cpp
cp ~/.vim/bundle/CCTree/ftplugin/cctree.vim ~/.vim/bundle/CCTree/ftplugin/c
cp ~/.vim/bundle/CCTree/ftplugin/cctree.vim ~/.vim/bundle/CCTree/ftplugin/cpp

