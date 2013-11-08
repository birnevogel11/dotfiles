#!/usr/bin/env bash

## Link dictionay and files
ln -s `pwd` ~/.vim
ln -s `pwd`/vimrc ~/.vimrc 

## Install Neobundle
mkdir ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

## Install all plugins
vim +NeoBundleInstall +qall

## CCtree setting
mkidr -p ~/.vim/bundle/CCTree/ftplugin/c
mkidr -p ~/.vim/bundle/CCTree/ftplugin/cpp
cp ~/.vim/bundle/CCTree/ftplugin/cctree.vim ~/.vim/bundle/CCTree/ftplugin/c
cp ~/.vim/bundle/CCTree/ftplugin/cctree.vim ~/.vim/bundle/CCTree/ftplugin/cpp

