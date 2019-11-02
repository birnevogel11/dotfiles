#!/usr/bin/env bash

set -ex

TOP_DIR=$(pwd)

# Determine the bin is vim or nvim
VIM_BIN=vim
if [ -x "$(command -v nvim)" ]; then
  VIM_BIN="nvim --headless"
fi

func::clear_setting() {
  # Remove current settings
  rm -rf ${HOME}/.vim/autoload/plug.vim
  rm -rf ${HOME}/.vim
  rm -rf ${HOME}/.vimrc
}

func::install_setting() {
  # Add new settings
  mkdir -p ${HOME}/.config
  ln -sf ${TOP_DIR}  ${HOME}/.config/nvim
  ln -sf ${HOME}/.config/nvim  ${HOME}/.vim

  # Install vim-plug
  curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # Install all plugins
  ${VIM_BIN} +PlugInstall +qall
}

post::set_pyenv() {
  # Check pyenv is installed
  if [[ -d $HOME/.pyenv/bin ]]; then
    export PATH="$HOME/.pyenv/bin:$HOME/.local/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    pip install --upgrade pynvim
  fi
}

post::set_golang_env(){
  # Check go is installed
  if [[ -d $HOME/Trek/go ]] && [[ -d $HOME/usr/go/bin ]]; then
    export GOPATH=$HOME/Trek/go
    export PATH=$GOPATH/bin:$HOME/usr/go/bin:$PATH
  fi
}

post::update_nvim_plugins(){
  if [[ -d $HOME/.pyenv/bin ]]; then
    pip install -U --user --no-cache pynvim pipenv
    ${VIM_BIN} +UpdateRemotePlugin +qall
  fi

  if [[ -f $HOME/usr/go/bin/go ]] && [[ -d $HOME/.vim/plugged/vim-go ]]; then
      ${VIM_BIN} +GoInstallBinaries +qall
  fi
}

func::post_setting() {
  post::set_pyenv
  post::set_golang_env
  post::update_nvim_plugins
}

main() {
  func::clear_setting
  func::install_setting
  func::post_setting
}

main
