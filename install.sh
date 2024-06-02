#!/usr/bin/env bash

# The script is only tested in Ubuntu jammy/noble and macOS 10.14.
set -euxo pipefail

if [[ "${UID}" == "0" ]]; then
  SUDO=""
else
  SUDO="sudo"
fi

# $HOST_OS is changed with func::determine_host_os
HOST_OS=""

readonly -a LIST_PACKAGES=(env mise pyenv docker)
# readonly DOCKER_BINARY_VERSION_DARWIN=20.10.7
readonly PYENV_PYTHON3_VERSION=3.12.2
readonly PROTOCOL_BUF_VERSION=3.17.3
readonly RIPGREP_VERSION=13.0.0

readonly TOP_DIR="${HOME}/usr"
readonly BIN_DIR="${TOP_DIR}/bin"
readonly SRC_DIR="${TOP_DIR}/src"

# shellcheck disable=SC2155
readonly MAKE_JOBS_OPTIONS="-j$(nproc)"

# GHCUP doesn't provide a good way to install it automatically. I stoped to
# hack the script and install it manually.
# func::install_hs() {
#   if [[ "${HOST_OS}" == "linux-arch" ]]; then
#     ${SUDO} pacman -S --noconfirm curl gcc gmp make ncurses coreutils xz
#   fi
#
#   curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org |
#     sed 's/read -r answer <\/dev\/tty//g' |
#     sed 's/read -r next_answer <\/dev\/tty/next_answer=No/g' |
#     sed 's/read -r hls_answer <\/dev\/tty/hls_answer=YES/g' |
#     sed 's/read -r stack_answer <\/dev\/tty/stack_answer=YES/g' |
#     sh
# }

func::install_mise() {
  curl https://mise.run | sh
  eval "$(mise activate bash)"

  mise settings set experimental true

  (
    cd "$HOME"
    mise activate --shims
  )

  func::install_mise-pkgs
}

func::install_mise-pkgs() {
  func::install_pyenv-prequirement

  mise use -g cargo:cargo-binstall

  local -a pkgs=(
    go
    node@lts
    bat
    bat-extras
    bottom
    cargo:bandwhich
    cargo:bob-nvim
    cargo:gitui
    delta
    dust
    exa
    fd
    github-cli
    gofumpt
    hyperfine
    jless
    jq
    lazygit
    revive
    ripgrep
    tokei
    watchexec
  )

  mise i -y "${pkgs[@]}"

  mise use -g node@lts
  mise use -g go
  mise use -g "${pkgs[@]}"
  mise use -g go:github.com/gokcehan/lf
}

func::install_neovim-from-source() {
  if [[ "${HOST_OS}" =~ linux-ubuntu* ]]; then
    # Build from source
    ${SUDO} apt install -y ninja-build gettext libtool libtool-bin autoconf \
      automake cmake g++ pkg-config unzip build-essential git
  elif [[ "${HOST_OS}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm ninja gettext libtool autoconf automake \
      cmake gcc pkg-config unzip
  else
    brew install ninja libtool automake cmake pkg-config gettext
  fi

  mkdir -p "${SRC_DIR}"
  cd "${SRC_DIR}"
  rm -rf "${SRC_DIR}/neovim"
  git clone https://github.com/neovim/neovim
  cd neovim
  git checkout nightly
  # git checkout v0.10.0

  local -r make_opts=("${MAKE_JOBS_OPTIONS}" "CMAKE_BUILD_TYPE=Release" "CMAKE_INSTALL_PREFIX=${HOME}/usr")
  make "${make_opts[@]}"
  make "${make_opts[@]}" install
}

func::install_python-prerequirement() {
  local -a pkgs=(
      build-essential
      libbz2-dev
      libc6-dev
      libffi-dev
      libgdbm-dev
      liblzma-dev
      libncursesw5-dev
      libreadline-dev
      libsqlite3-dev
      libssl-dev
      lzma
      openssl
      python-is-python3
      python3-dev
      python3-pip
      python3-setuptools
      python3-smbus
      python3-venv
      tk-dev
      zlib1g-dev
  )
  if [[ "${HOST_OS}" =~ linux-ubuntu* ]]; then
    ${SUDO} apt install -y "${pkgs[@]}"
  elif [[ "${HOST_OS}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm base-devel curl ncurses gdbm zlib sqlite3 \
      tk openssl libffi readline
  fi
}

func::install_pyenv() {
  func::install_pyenv-prequirement

  curl https://pyenv.run | bash

  export PATH="${HOME}/.pyenv/bin:${PATH}"
  if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
  fi

  if [[ "${HOST_OS}" =~ linux* ]]; then
    pyenv install -f -v ${PYENV_PYTHON3_VERSION}
  else
    if [[ ${MACOS_VERSION} == "10.14" ]]; then
      SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX${MACOS_VERSION}.sdk MACOSX_DEPLOYMENT_TARGET=10.14 pyenv install -f -v ${PYENV_PYTHON3_VERSION}
    else
      pyenv install -f -v ${PYENV_PYTHON3_VERSION}
    fi
  fi
  pyenv global ${PYENV_PYTHON3_VERSION}
}

func::install_jumper() {
  pushd "${SRC_DIR}"

  rm -rf jumper

  git clone https://github.com/homerours/jumper
  cd jumper
  make jumper FLAGS="-O2 -flto"

  cp jumper "${HOME}/.local/bin/jumper"
  mkdir -p "${HOME}/.local/share/jumper"
  cp ./shell/* "${HOME}/.local/share/jumper/"
  mkdir -p "${HOME}/.jumper"

  popd
}

func::install_docker() {
  if [[ "${HOST_OS}" =~ linux-ubuntu* ]]; then
    curl -sSL https://get.docker.com | ${SUDO} sh
  elif [[ "${HOST_OS}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm docker
  else
    echo "Please install docker package directly."
    exit 2
  fi

  if [[ "${HOST_OS}" =~ linux* ]] && [[ -n ${USER} ]] && [[ "${USER}" != "root" ]]; then
    ${SUDO} usermod -aG docker "${USER}"
  fi

  ${SUDO} systemctl enable docker || true
  ${SUDO} systemctl start docker || true
}

func::install_tmux-mem-cpu-load() {
  if [[ "${HOST_OS}" =~ linux* ]]; then
    local -r src_dir="${SRC_DIR}/tmux-mem-cpu-load"
    rm -rf "${src_dir}"
    git clone https://github.com/thewtex/tmux-mem-cpu-load/ "${src_dir}"

    pushd "${src_dir}"

    cmake . -DCMAKE_INSTALL_PREFIX="${HOME}/usr"
    # shellcheck disable=SC2046
    make "${MAKE_JOBS_OPTIONS}"
    make install

    popd
  else
    brew install tmux-mem-cpu-load
  fi
}

# func::install_docker-binary() {
#   if [[ "${HOST_OS}" =~ linux* ]]; then
#     local -r docker_version=${DOCKER_BINARY_VERSION_LINUX}
#     local -r platform="linux"
#   else
#     local -r docker_version=${DOCKER_BINARY_VERSION_DARWIN}
#     local -r platform="mac"
#   fi
#
#   local -r bin_file="docker_${docker_version}.tgz"
#   local -r download_url=https://download.docker.com/${platform}/static/stable/x86_64/docker-${DOCKER_BINARY_VERSION_LINUX}.tgz
#
#   func::help::create_tmp_work_dir
#
#   curl -s -L ${download_url} -o ${bin_file}
#   tar xf ${bin_file}
#   mv docker/* "${BIN_DIR}"
#
#   func::help::clean_tmp_work_dir
# }

func::install_neovim-bob() {
  mise i -y cargo:bob-nvim
  bob install nightly
  bob use nightly
}

func::install_ripgrep() {
  if [[ "${HOST_OS}" =~ linux-ubuntu* ]]; then
    wget -q "https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}_amd64.deb"
    ${SUDO} dpkg -i ./ripgrep_*_amd64.deb
    rm -rf ./ripgrep_*_amd64.deb
  elif [[ "${HOST_OS}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm ripgrep
  else
    brew install ripgrep
  fi
}

func::install_rust() {
  if [[ ! -f "${HOME}/.cargo/bin/rustup" ]]; then
    local -r install_script="/tmp/rustup_install.sh"
    rm -rf "${install_script}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs >"${install_script}"
    chmod +x ${install_script}

    ${install_script} -y
    rm -rf ${install_script}

    export PATH="${HOME}/.cargo/bin:${PATH}"
  fi

  # Install rustfmt
  rustup component add rustfmt
  rustup component add rust-analyzer

  rustup update stable

  # Install zr
  cargo install zr
}

func::install_alactirry() {
  if [[ "${HOST_OS}" =~ linux* ]]; then
    local -r src_dir="${SRC_DIR}/alacritty"
    rm -rf "${src_dir}"
    git clone https://github.com/alacritty/alacritty "${src_dir}"

    pushd "${src_dir}"
    git checkout v0.13.2

    cargo build --release

    sudo cp target/release/alacritty /usr/local/bin
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database

    popd
  fi
}

func::install_sublimetext() {
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  sudo apt-get install apt-transport-https
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  sudo apt-get update
  sudo apt-get install -y sublime-text
}

func::install_env-ubuntu() {
  local pkgs=(
    ansiweather
    autoconf
    bison
    bridge-utils
    build-essential
    ccache
    cmake
    cscope
    curl
    flex
    git
    htop
    inotify-tools
    iproute2
    jq
    libgmp-dev
    libnotify-bin
    libtool
    ncdu
    neovim
    net-tools
    p7zip-full
    p7zip-rar
    pbzip2
    pigz
    psmisc
    python-is-python3
    python3
    screenfetch
    shellcheck
    tig
    tmux
    tree
    universal-ctags
    unzip
    wget
    zsh
    zstd
  )
  ${SUDO} apt update
  ${SUDO} apt upgrade -y
  ${SUDO} apt install -y "${pkgs[@]}"

  # Install latest git
  ${SUDO} add-apt-repository ppa:git-core/ppa
  ${SUDO} apt update
  ${SUDO} apt install -y git
}

func::install_env-arch() {
  ${SUDO} pacman -Syu --noconfirm
  ${SUDO} pacman -S --noconfirm coreutils python3 ctags cscope curl wget zsh \
    tmux neovim git tig htop unzip the_silver_searcher \
    base-devel jq tree inotify-tools net-tools bc llvm clang cmake \
    iproute2 bridge-utils psmisc inetutils \
    pigz pbzip2 p7zip xz
}

func::install_env-macOS() {
  # Ref: https://github.com/pyenv/pyenv/issues/1219
  xcode-select --install || true
  if [[ "${MACOS_VERSION}" == "10.14" ]]; then
    local -r pkg_path="/Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_${MACOS_VERSION}.pkg"
    ${SUDO} installer -pkg "${pkg_path}" -target / || true
  fi

  brew update
  brew upgrade
  brew install zsh python@2 python@3 ctags cscope curl wget tmux vim p7zip \
    neovim git tig ag ripgrep htop jq diff-so-fancy tree pstree \
    watchexec make gnu-tar gnu-time gnu-which gnu-sed rsync coreutils iproute2mac tmuxinator shellcheck fd \
    screenfetch weather ccache reattach-to-user-namespace \
    shfmt sd ncdu
}

func::install_env() {
  if [[ "${HOST_OS}" =~ linux-ubuntu* ]]; then
    func::install_env-ubuntu
  elif [[ "${HOST_OS}" == "linux-arch" ]]; then
    func::install_env-arch
  else
    func::install_env-macOS
  fi
}

func::help::create_tmp_work_dir() {
  local -r work_dir="${TOP_DIR}/tmp_work"

  rm -rf "${work_dir}"
  mkdir -p "${work_dir}"
  cd "${work_dir}"
}

func::help::clean_tmp_work_dir() {
  local -r work_dir="${TOP_DIR}/tmp_work"

  cd "${TOP_DIR}"
  rm -rf "${work_dir}"
}

func::install_package() {
  package_name=$1
  func_name="func::install_$(eval "echo ${package_name}")"
  if [[ -n "$(type -t "${func_name}")" ]] && [[ "$(type -t "${func_name}")" = function ]]; then
    echo "Install ${package_name}"
    $func_name
  else
    echo "No package named ${package_name}"
  fi
}

func::determine_host_os() {
  local -r platform=$(uname | tr '[:upper:]' '[:lower:]')

  if [[ "${platform}" == "darwin" ]]; then
    if [[ "$(sw_vers | grep ProductVersion | awk '{print $2}')" == "10.14*" ]]; then
      readonly MACOS_VERSION="10.14"
    fi
    HOST_OS="${platform}"
  elif [[ "${platform}" == "linux" ]]; then
    local -r linux_distro=$(grep "^ID" /etc/os-release | head -n1 | awk -F'=' '{print $2}')
    if [[ "${linux_distro}" == "ubuntu" ]] || [[ "${linux_distro}" == "pop" ]]; then
      local -r version_num=$(grep VERSION /etc/os-release | head -n1 | awk -F'=' '{print $2}' | sed 's/"//g' | awk '{print $1}')
      if [[ "${version_num}" =~ 20.04* ]]; then
        HOST_OS="linux-ubuntu-focal"
      elif [[ "${version_num}" =~ 22.04* ]]; then
        HOST_OS="linux-ubuntu-jammy"
      elif [[ "${version_num}" =~ 24.04* ]]; then
        HOST_OS="linux-ubuntu-noble"
      else
        echo "Unsupported for the ubuntu version ${version_num}"
        exit 1
      fi
    elif [[ "${linux_distro}" == "arch" ]]; then
      HOST_OS="linux-arch"
    else
        echo "Unsupported for the linux distro: ${linux_distro}"
        exit 1
    fi
  else
      echo "Unsupported for the platform: ${platform}"
      exit 1
  fi
}

func::install_all() {
  for package in "${LIST_PACKAGES[@]}"; do
    func::install_package "${package}"
  done
}

main() {
  mkdir -p "${TOP_DIR}" "${BIN_DIR}" "${SRC_DIR}"

  func::determine_host_os

  if [[ $# -eq 0 ]]; then
    # Install dotfiles
    ./install_dotfiles.sh

    # Install all packages
    func::install_all
  else
    for args in "$@"; do
      # shellcheck disable=SC2086
      func::install_package $args
    done
  fi
}

main "$@"
