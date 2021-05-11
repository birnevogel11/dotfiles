#!/usr/bin/env bash

set -ex

PLATFORM="$(uname)"
readonly PLATFORM="$(echo "${PLATFORM}" | tr '[:upper:]' '[:lower:]')"

readonly TOP_DIR="$(pwd)"
readonly TOP_CONFIG_DIR=${HOME}/.config/${USER}
readonly ZSH_CONFIG_DIR=${TOP_CONFIG_DIR}/zsh

func::install_zsh_config() {
  mkdir -p "${HOME}/.config"
  ln -sf "${TOP_DIR}" "${TOP_CONFIG_DIR}"

  # Install zinit
  rm -rf "${HOME}/.zinit"
  mkdir "${HOME}/.zinit"
  git clone https://github.com/zdharma/zinit.git "${HOME}/.zinit/bin"

  # Remove all old links
  (
    cd "${HOME}"
    rm -rf .zprezto .zlogin .zlogout .zprofile .zshenv .zshrc .zpreztorc
  )

  # Link zsh setting
  ln -sf "${ZSH_CONFIG_DIR}/zshrc"                   "${HOME}/.zshrc"
}

func::copy_dotfiles() {
  # tmux
  cp "${TOP_DIR}/config/tmux.conf" "${HOME}/.tmux.conf"

  # gitconfig
  cp "${TOP_DIR}/config/gitconfig.${PLATFORM}" "${HOME}/.gitconfig"

  # ghci
  mkdir -p "${HOME}/.ghc"
  rm -rf "${HOME}/.ghc/ghci.conf"
  ln -sf "${TOP_DIR}/config/ghci.conf" "${HOME}/.ghc/ghci.conf"

  # cgdb
  cp "${TOP_DIR}/config/cgdbrc" "${HOME}/.cgdbrc"

  # tig
  cp "${TOP_DIR}/config/tigrc" "${HOME}/.tigrc"

  # htop
  mkdir -p "${HOME}/.config/htop"
  cp "${TOP_DIR}/config/htoprc" "${HOME}/.config/htop/htoprc"

  # ssh
  mkdir -p "${HOME}/.ssh"
  cp "${TOP_DIR}/config/ssh_rc" "${HOME}/.ssh/rc"

  # lf
  mkdir -p "${HOME}/.config/lf"
  cp "${TOP_DIR}/config/lfrc_${PLATFORM}" "${HOME}/.config/lf/lfrc"
  curl https://raw.githubusercontent.com/gokcehan/lf/master/etc/lfcd.sh -o ~/.config/lf/lfcd.sh

  # alacritty
  mkdir -p "${HOME}/.config/alacritty"
  cp "${TOP_DIR}/config/alacritty_${PLATFORM}.yml" "${HOME}/.config/alacritty/alacritty.yml"
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
  func::install_zsh_config
  func::copy_dotfiles
  func::install_vim_config
  func::config_git_user
}

main "$@"
