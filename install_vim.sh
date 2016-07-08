#!/usr/bin/env bash

CURRENT_PATH=`pwd`

## remove the previous link
rm -rf $HOME/.vim
rm -rf $HOME/.vimrc
rm -rf $HOME/.gvimrc

## Link dictionay and files
ln -s $CURRENT_PATH ~/.vim
ln -s $CURRENT_PATH/vimrc ~/.vimrc 
ln -s $CURRENT_PATH/gvimrc ~/.gvimrc 

## Install Neobundle
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

## Install all plugins
vim +NeoBundleInstall +qall

