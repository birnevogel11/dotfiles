#!/usr/bin/env bash

set -ex

TOP_DIR=$(pwd)

# Determine the bin is vim or nvim
VIM_BIN=vim
if [ -x "$(command -v nvim)" ]; then
  VIM_BIN="nvim --headless"
fi

if [ -f "${HOME}/usr/bin/nvim" ]; then
  VIM_BIN="${HOME}/usr/bin/nvim --headless"
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

vim::install_vim_plug() {
  local -r download_url="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  local -r plug_file="${HOME}/.vim/autoload/plug.vim"

  rm -rf "${HOME}/.cache/vim-plug"
  rm -rf ${plug_file}

  curl -fLo "${plug_file}" --create-dirs "${download_url}"
  vim::update_plugins
}

vim::update_plugins() {
  ${VIM_BIN} "+PlugInstall" "+PlugUpdate" "+UpdateRemotePlugin" "+qall"
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

post::set_rust_env() {
  mkdir -p ${HOME}/.cache

  # Clone rust src
  local -r rust_src_path="${HOME}/.cache/rust-src"
  git clone --depth=1 https://github.com/rust-lang/rust.git ${rust_src_path}

  # Install racer and rust fmt
  if [[ -d "${HOME}/.cargo/bin" ]]; then
    export PATH="${HOME}/.cargo/bin:${PATH}"

    rustup update

    # racer
    rustup toolchain add nightly
    cargo +nightly install racer

    # rustfmt
    rustup component add rustfmt
  fi
}

post::install_plugin_externals(){
  if [[ -f "${HOME}/.pyenv/shims/pip" ]]; then
    ${HOME}/.pyenv/shims/pip install -U --no-cache-dir pynvim six
    ${VIM_BIN} +UpdateRemotePlugin +qall
  fi

  # if [[ -f ${HOME}/usr/go/bin/go ]]; then
  # ${VIM_BIN} /tmp/test.go +GoInstallBinaries +qall
  # fi
}

vim::post_setting() {
  post::set_pyenv
  post::set_golang_env
  post::install_plugin_externals
}

main() {
  case "$1" in
    plug)
      vim::install_vim_plug
      ;;
    update)
      vim::update_plugins
      ;;
    *)
      vim::clear_setting
      vim::install_setting
      vim::install_vim_plug
      vim::post_setting
      ;;
  esac
}

main $@
