#!/usr/bin/env bash

set -ex

./install_binary.sh all
./install_dotfiles.sh

if [[ -f "${HOME}/usr/rc_local/install_dotfiles.sh" ]]; then
  cd "${HOME}"/usr/rc_local
  ./install_dotfiles.sh
fi
