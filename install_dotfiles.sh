#!/usr/bin/env bash

set -ex

PLATFORM=$(uname)
readonly PLATFORM=$(echo "${PLATFORM}" | tr '[:upper:]' '[:lower:]')

readonly TOP_DIR=$(pwd)
readonly TOP_CONFIG_DIR=${HOME}/.config/${USER}
readonly ZSH_CONFIG_DIR=${TOP_CONFIG_DIR}/zsh
readonly REPO_DIR="${HOME}/.cache/repo"

# Download github repo to REPO_DIR
#
# $1: repo_url
# $2: repo location (optional)
func::download_repo() {
  local -r repo_url="$1"
  if [[ -n "$2" ]]; then
    local -r repo_dir="$2"
  else
    local -r repo_dir="${REPO_DIR}/${repo_url##*/}"
  fi

  mkdir -p "${REPO_DIR}"
  if [[ ! -d "${repo_dir}" ]]; then
    git clone --recursive "${repo_url}" "${repo_dir}"
  fi
}

func::install_zsh_config() {
  mkdir -p "${HOME}/.config"
  ln -sf "${TOP_DIR}" "${TOP_CONFIG_DIR}"

  # Download zsh repos
  func::download_repo https://github.com/sorin-ionescu/prezto
  func::download_repo https://github.com/belak/prezto-contrib "${REPO_DIR}/prezto/contrib"
  func::download_repo https://github.com/zsh-users/zsh-autosuggestions
  func::download_repo https://github.com/rupa/z

  # Remove all old links
  for name in .zprezto .zlogin .zlogout .zprofile .zshenv .zshrc .zpreztorc; do
    rm -f "${HOME}/${name}"
  done

  local -r prezto_repo_dir="${REPO_DIR}/prezto"

  # Link prezto
  ln -sf "${prezto_repo_dir}"                        "${HOME}/.zprezto"
  ln -sf "${prezto_repo_dir}/runcoms/zlogin"         "${HOME}/.zlogin"
  ln -sf "${prezto_repo_dir}/runcoms/zlogout"        "${HOME}/.zlogout"
  ln -sf "${prezto_repo_dir}/runcoms/zprofile"       "${HOME}/.zprofile"
  ln -sf "${prezto_repo_dir}/runcoms/zshenv"         "${HOME}/.zshenv"

  # Link zsh setting
  ln -sf "${ZSH_CONFIG_DIR}/zshrc"                   "${HOME}/.zshrc"
  ln -sf "${ZSH_CONFIG_DIR}/zpreztorc"               "${HOME}/.zpreztorc"
  ln -sf "${ZSH_CONFIG_DIR}/prompt/prompt_yen3next_setup" \
    "${HOME}/.zprezto/modules/prompt/functions/prompt_yen3next_setup"
}

func::copy_dotfiles() {
  # tmux
  cp "${TOP_DIR}/config/tmux.conf" "${HOME}/.tmux.conf"

  # gitconfig
  cp "${TOP_DIR}/config/gitconfig.${PLATFORM}" "${HOME}/.gitconfig"

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

func::update_repos() {
  for name in "${REPO_DIR}"/*; do
    (cd "${name}" \
     && git pull --rebase \
     && git submodule update --init --recursive)
  done

  if [[ -d "${REPO_DIR}/prezto/contrib" ]]; then
    cd "${REPO_DIR}/prezto/contrib"
    git pull --rebase
    git submodule update --init --recursive
  fi
}

main() {
  local -r command="$1"

  if [[ "${command}" == "update" ]]; then
    func::update_repos
    exit $?
  fi

  func::install_zsh_config
  func::copy_dotfiles
  func::install_vim_config
  func::config_git_user
}

main "$@"
