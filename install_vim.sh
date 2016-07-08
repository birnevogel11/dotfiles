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

## Install dein.vim 
mkdir -p ~/.vim/dein
cd ~/.vim/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
chmod +x ./installer.sh
./installer.sh ~/.vim/dein


