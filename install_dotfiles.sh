#!/usr/bin/env bash

set -ex

PLATFORM="$(uname)"
# shellcheck disable=SC2155
readonly PLATFORM="$(echo "${PLATFORM}" | tr '[:upper:]' '[:lower:]')"

# shellcheck disable=SC2155
readonly TOP_DIR="$(pwd)"
readonly TOP_CONFIG_DIR=${HOME}/.config/${USER}
readonly ZSH_CONFIG_DIR=${TOP_CONFIG_DIR}/zsh

func::link_config_dir() {
  mkdir -p "${HOME}/.config"
  rm -f "${TOP_CONFIG_DIR}"
  ln -sf "${TOP_DIR}" "${TOP_CONFIG_DIR}"
}

func::install_zsh_config() {
  # Install zinit
  rm -rf "${HOME}/.zinit"
  mkdir "${HOME}/.zinit"
  git clone https://github.com/zdharma-continuum/zinit.git "${HOME}/.zinit/bin"

  # Remove all old links
  (
    cd "${HOME}"
    rm -rf .zprezto .zlogin .zlogout .zprofile .zshenv .zshrc .zpreztorc
  )

  # Link zsh setting
  ln -sf "${ZSH_CONFIG_DIR}/zshrc" "${HOME}/.zshrc"
}

func::copy_dotfiles() {
  # tmux
  cp "${TOP_DIR}/config/xdg_config/tmux/tmux.conf" "${HOME}/.tmux.conf"

  # gitconfig
  cp "${TOP_DIR}/config/xdg_config/git/gitconfig.${PLATFORM}" "${HOME}/.gitconfig"

  # ghci
  mkdir -p "${HOME}/.ghc"
  rm -rf "${HOME}/.ghc/ghci.conf"
  ln -sf "${TOP_DIR}/config/ghc/ghci.conf" "${HOME}/.ghc/ghci.conf"

  # cgdb
  cp "${TOP_DIR}/config/cgdbrc" "${HOME}/.cgdbrc"

  # tig
  cp "${TOP_DIR}/config/tigrc" "${HOME}/.tigrc"

  # ssh
  mkdir -p "${HOME}/.ssh"
  cp "${TOP_DIR}/config/ssh/ssh_rc" "${HOME}/.ssh/rc"

  for path in "${TOP_DIR}"/config/xdg_config/*; do
    local name="$(basename "${path}")"
    rm -rf "${HOME}/.config/${name}"
    ln -sf "${TOP_DIR}/config/xdg_config/${name}" "${HOME}/.config/${name}"
  done
}

func::install_vim_config() {
  # Download vim plugins and install
  (cd vim \
   && ./install_vim.sh)
}

func::config_git_user(){
  git config --global user.name "yen3"
  git config --global user.email "yen3rc@gmail.com"
}

main() {
  func::link_config_dir
  func::install_zsh_config
  func::copy_dotfiles
  func::install_vim_config
  func::config_git_user
}

main "$@"
