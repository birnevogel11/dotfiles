#!/usr/bin/env bash

TOP_DIR=$(pwd)

if [ -x "$(command -v nvim)" ]; then
    VIM_BIN=nvim
else
    VIM_BIN=vim
fi

## Remove previous settings
rm -rf ${HOME}/.vim
rm -rf ${HOME}/.vimrc
rm -rf ${HOME}/.gvimrc
rm -rf ${HOME}/.config/nvim/init.vim

## Link/Copy settings
mkdir -p ${HOME}/.config/nvim

ln -s ${TOP_DIR}            ${HOME}/.vim
ln -s ${TOP_DIR}/vimrc      ${HOME}/.vimrc
ln -s ${TOP_DIR}/gvimrc     ${HOME}/.gvimrc
ln -s ${TOP_DIR}/init.vim   ${HOME}/.config/nvim/init.vim

## Install vim-plug and all plugins
curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

${VIM_BIN} +PlugInstall +qall

if [ -f $HOME/usr/go/bin/go ]; then
    mkdir -p ${HOME}/Trek/go
    mkdir -p ${HOME}/Trek/go/bin
    export GOPATH=$HOME/Trek/go
    export PATH=$HOME/usr/go/bin:$HOME/usr/go/bin:$PATH
    ${VIM_BIN} +GoInstallBinaries +GoUpdateBinaries +qall
fi

