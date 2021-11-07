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

vim::install_vim_packer() {
  local -r packer_dir="${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"
  rm -rf "${packer_dir}"
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "${packer_dir}" 

}

vim::update_plugins() {
  ${VIM_BIN} "+PackerInstall" "+PackerCompile" "+qall"
}

main() {
  case "$1" in
    packer)
      vim::install_vim_packer
      ;;
    update)
      vim::update_plugins
      ;;
    *)
      vim::clear_setting
      vim::install_setting
      vim::install_vim_packer
      vim::update_plugins
      ;;
  esac
}

main "$@"
