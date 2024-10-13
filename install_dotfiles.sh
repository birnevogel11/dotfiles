#!/usr/bin/env bash

set -Eeuxo pipefail

PLATFORM="$(uname)"
# shellcheck disable=SC2155
readonly PLATFORM="$(echo "${PLATFORM}" | tr '[:upper:]' '[:lower:]')"
# shellcheck disable=SC2155
readonly BASE_CONFIG_DIR="$(pwd)/xdg_config"

dotfile::initialize_config_dir() {
  mkdir -p "${HOME}/.config"
  # rm -f "${TOP_CONFIG_DIR}"
  # ln -sf "${BASE_CONFIG_DIR}" "${TOP_CONFIG_DIR}"
}

dotfile::install_zsh() {
  local -r zsh_config_dir="${BASE_CONFIG_DIR}/zsh"

  # Remove all old links
  (
    cd "${HOME}"
    rm -rf .zprezto .zlogin .zlogout .zprofile .zshenv .zshrc .zpreztorc
  )

  # Link zsh setting
  ln -sf "${zsh_config_dir}/zshrc" "${HOME}/.zshrc"
  ln -sf "${zsh_config_dir}" "${HOME}/.config/zsh"

  mkdir -p "${HOME}/.zfunc"
  cp -rv ${zsh_config_dir}/zfunc/* "${HOME}/.zfunc"
}

dotfile::install_dotfiles() {
  # tmux
  ln -sf "${BASE_CONFIG_DIR}/tmux/tmux.conf" "${HOME}/.tmux.conf"

  # gitconfig
  ln -sf "${BASE_CONFIG_DIR}/git/gitconfig.${PLATFORM}" "${HOME}/.gitconfig"

  # ghci
  mkdir -p "${HOME}/.ghc"
  rm -rf "${HOME}/.ghc/ghci.conf"
  ln -sf "${BASE_CONFIG_DIR}/ghc/ghci.conf" "${HOME}/.ghc/ghci.conf"

  # cgdb
  ln -sf "${BASE_CONFIG_DIR}/cgdb/cgdbrc" "${HOME}/.cgdbrc"

  # tig
  ln -sf "${BASE_CONFIG_DIR}/tig/tigrc" "${HOME}/.tigrc"

  # ssh
  mkdir -p "${HOME}/.ssh"
  ln -sf "${BASE_CONFIG_DIR}/ssh/ssh_rc" "${HOME}/.ssh/rc"
}

dotfile::install_config_dir() {
  for path in "${BASE_CONFIG_DIR}"/*; do
    local name="$(basename "${path}")"
    rm -rf "${HOME}/.config/${name}"
    ln -sf "${BASE_CONFIG_DIR}/${name}" "${HOME}/.config/${name}"
  done
}

dotfile::install_nvim() {
  local -r nvim_config_dir="${HOME}/.config/nvim"
  if [[ -L "${nvim_config_dir}" ]]; then
    rm "${nvim_config_dir}"
  fi
  ln -sf "${BASE_CONFIG_DIR}/nvim"  "${HOME}/.config/nvim"
}

dotfile::install_local() {
    if [[ -f "${HOME}/usr/rc_local/install_dotfiles.sh" ]]; then
      cd "${HOME}"/usr/rc_local
      ./install_dotfiles.sh
    fi
}

dotfile::install_git-user(){
  git config --global user.name "Birne Vogel"
  git config --global user.email "birnevogel11@gmail.com"
}

dotfile::install_all() {
  dotfile::initialize_config_dir
  dotfile::install_dotfiles
  # dotfile::link_conifg
  dotfile::install_zsh
  dotfile::install_nvim
  dotfile::install_git-user
  dotfile::install_local
}

dotfile::install_single() {
  package_name=$1
  func_name="dotfile::install_${package_name}"
  if [[ -n "$(type -t "${func_name}")" ]] && [[ "$(type -t "${func_name}")" = function ]]; then
    echo "Execute ${func_name}"
    $func_name
  else
    echo "No func named ${func_name}"
  fi
}

main() {
  if [[ $# -eq 0 ]]; then
    dotfile::install_all
  else
    for arg in "$@"; do
      # shellcheck disable=SC2086
      dotfile::install_single $arg
    done
  fi
}

main "$@"
