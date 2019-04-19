#!/usr/bin/env bash

TOP_DIR=$(pwd)

# Determine the bin is vim or nvim
VIM_BIN=vim
if [ -x "$(command -v nvim)" ]; then
  VIM_BIN="nvim --headless"
fi

# Remove current settings
rm -rf ${HOME}/.vim/autoload/plug.vim
rm -rf ${HOME}/.vim
rm -rf ${HOME}/.vimrc
rm -rf ${HOME}/.gvimrc
rm -rf ${HOME}/.config/nvim/init.vim

# Add new settings
mkdir -p ${HOME}/.config/nvim
ln -sf ${TOP_DIR}            ${HOME}/.vim
ln -sf ${TOP_DIR}/vimrc      ${HOME}/.vimrc
ln -sf ${TOP_DIR}/gvimrc     ${HOME}/.gvimrc
ln -sf ${TOP_DIR}/init.vim   ${HOME}/.config/nvim/init.vim

# Install vim-plug
curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install all plugins
${VIM_BIN} +PlugInstall +qall

