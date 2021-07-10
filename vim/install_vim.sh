#!/usr/bin/env bash

set -ex

TOP_DIR="$(pwd)"

VIM_BIN="nvim --headless"
if [ -f "${HOME}/usr/bin/nvim" ]; then
  VIM_BIN="${HOME}/usr/bin/nvim --headless"
fi

vim::clear_setting() {
  local -r nvim_config_dir="${HOME}/.config/nvim"
  if [[ -h "${nvim_config_dir}" ]]; then
    rm "${nvim_config_dir}"
  fi
}

vim::install_setting() {
  # Add new settings
  mkdir -p "${HOME}/.config"
  ln -sf "${TOP_DIR}"  "${HOME}/.config/nvim"
}

vim::install_vim_plug() {
  local -r download_url="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  local -r plug_file="${HOME}/.vim/autoload/plug.vim"

  rm -rf "${HOME}/.cache/vim-plug"
  rm -rf "${plug_file}"

  curl -fLo "${plug_file}" --create-dirs "${download_url}"
}

vim::update_plugins() {
  ${VIM_BIN} "+PlugInstall" "+PlugUpdate" "+UpdateRemotePlugin" "+qall"
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
      vim::update_plugins
      ;;
  esac
}

main "$@"
