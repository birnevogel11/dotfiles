#!/usr/bin/env bash

set -ex

TOP_DIR="$(pwd)"

NVIM_BIN="nvim --headless"
if [ -f "${HOME}/usr/bin/nvim" ]; then
  NVIM_BIN="${HOME}/usr/bin/nvim --headless"
fi

nvim::clear_setting() {
  local -r nvim_config_dir="${HOME}/.config/nvim"
  if [[ -h "${nvim_config_dir}" ]]; then
    rm "${nvim_config_dir}"
  fi
}

nvim::install_setting() {
  # Add new settings
  mkdir -p "${HOME}/.config"
  ln -sf "${TOP_DIR}"  "${HOME}/.config/nvim"
}

nvim::install_vim_packer() {
  local -r packer_dir="${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"
  rm -rf "${packer_dir}"
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "${packer_dir}"
}

nvim::update_plugins() {
  ${NVIM_BIN} "+PackerInstall" "+PackerCompile" "+qall"
}

main() {
  case "$1" in
    packer)
      nvim::install_vim_packer
      ;;
    update)
      nvim::update_plugins
      ;;
    *)
      # nvim::clear_setting
      nvim::install_setting
      # nvim::install_vim_packer
      # nvim::update_plugins
      ;;
  esac
}

main "$@"
