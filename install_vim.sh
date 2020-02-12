#!/usr/bin/env bash

set -ex

TOP_DIR=$(pwd)

# Determine the bin is vim or nvim
VIM_BIN=vim
if [ -x "$(command -v nvim)" ]; then
  VIM_BIN="nvim --headless"
fi

vim::clear_setting() {
  # Remove current settings
  rm -rf ${HOME}/.vim/autoload/plug.vim
  rm -rf ${HOME}/.vim
  rm -rf ${HOME}/.vimrc
}

vim::install_setting() {
  # Add new settings
  mkdir -p ${HOME}/.config
  ln -sf ${TOP_DIR}  ${HOME}/.config/nvim
  ln -sf ${HOME}/.config/nvim  ${HOME}/.vim
}

vim::install_dein_vim() {
  local -r plugin_dir="$HOME/.cache/dein"
  local -r dein_github_repo="https://github.com/Shougo/dein.vim"
  local -r dein_install_dir="${plugin_dir}/repos/github.com/Shougo/dein.vim"

  rm -rf ${plugin_dir}

  mkdir -p ${plugin_dir}
  git clone ${dein_github_repo} ${dein_install_dir}

  # Install all plugins
  ${VIM_BIN} "+call dein#install()" "+qall"
}

vim::update_plugins() {
  ${VIM_BIN} "+call dein#install()" "+call dein#update()" "+qall"
}

post::set_pyenv() {
  # Check pyenv is installed
  if [[ -d ${HOME/.pyenv/bin} ]]; then
    export PATH="${HOME}/.pyenv/bin:${HOME}/.local/bin:${PATH}"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi
}

post::set_golang_env(){
  # Check go is installed
  if [[ -d $HOME/Trek/go ]] && [[ -d $HOME/usr/go/bin ]]; then
    export GOPATH=${HOME}/Trek/go
    export PATH=${HOME}/bin:${HOME}/usr/go/bin:${PATH}
  fi
}

post::install_plugin_externals(){
  if [[ -f "${HOME}/.pyenv/shims/pip" ]]; then
    ${HOME}/.pyenv/shims/pip install -U --no-cache-dir pynvim
    ${VIM_BIN} +UpdateRemotePlugin +qall
  fi

  if [[ -f ${HOME}/usr/go/bin/go ]]; then
    ${VIM_BIN} +GoInstallBinaries +qall
  fi
}

vim::post_setting() {
  post::set_pyenv
  post::set_golang_env
  post::install_plugin_externals
}

main() {
  case "$1" in
    dein)
      vim::install_dein_vim
      ;;
    update)
      vim::update_plugins
      ;;
    *)
      vim::clear_setting
      vim::install_setting
      vim::install_dein_vim
      vim::post_setting
      ;;
  esac
}

main $@
