#!/usr/bin/env bash

set -euxo pipefail

TOP_DIR="$(pwd)"

nvim::clear_setting() {
  local -r nvim_config_dir="${HOME}/.config/nvim"
  if [[ -L "${nvim_config_dir}" ]]; then
    rm "${nvim_config_dir}"
  fi
}

main() {
  nvim::clear_setting

  mkdir -p "${HOME}/.config"
  ln -sf "${TOP_DIR}"  "${HOME}/.config/nvim"
}

main "$@"
