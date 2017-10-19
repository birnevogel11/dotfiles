#!/usr/bin/env bash

CURRENT_PATH=`pwd`


VIM_BIN=vim
if [ -x "$(command -v nvim)" ]; then
    VIM_BIN=nvim
fi

## Remove previous settings
rm -rf $HOME/.vim
rm -rf $HOME/.vimrc
rm -rf $HOME/.gvimrc
rm -rf $HOME/.config/nvim/init.vim
mkdir -p $HOME/.config/nvim

## Link/Copy settings
ln -s $CURRENT_PATH          $HOME/.vim
ln -s $CURRENT_PATH/vimrc    $HOME/.vimrc
ln -s $CURRENT_PATH/gvimrc   $HOME/.gvimrc
ln -s $CURRENT_PATH/init.vim $HOME/.config/nvim/init.vim

## Install vim-plug and all plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

${VIM_BIN} +PlugInstall +qall

