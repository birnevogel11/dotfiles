#!/usr/bin/env bash

# The script is only tested in Ubuntu focal/jammy and macOS 10.14.
set -ex

if [[ "${UID}" == "0" ]]; then
  SUDO=""
else
  SUDO="sudo"
fi

PLATFORM=$(uname)
# shellcheck disable=SC2155
readonly PLATFORM=$(echo "${PLATFORM}" | tr '[:upper:]' '[:lower:]')
if [[ "${PLATFORM}" == "darwin" ]]; then
  if [[ "$(sw_vers | grep ProductVersion | awk '{print $2}')" == "10.14*" ]]; then
    readonly MACOS_VERSION="10.14"
  fi
fi
TARGET_PLATFORM="${PLATFORM}"

readonly LIST_PACKAGES="env neovim-bob pyenv docker-binary docker nvm"
readonly DOCKER_BINARY_VERSION_DARWIN=20.10.7
readonly DOCKER_BINARY_VERSION_LINUX=20.10.17
readonly PYENV_PYTHON3_VERSION=3.11.2
readonly GOENV_GO_VERSION=1.19.5
readonly RUST_ANALYZER_VERSION=2023-01-30
readonly PROTOCOL_BUF_VERSION=3.17.3
readonly NVM_VERSION=0.39.1
readonly RIPGREP_VERSION=13.0.0
readonly WATCHEXEC_VERSION=1.20.5
readonly GH_VERSION=2.21.1

readonly TOP_DIR="${HOME}/usr"
readonly BIN_DIR="${TOP_DIR}/bin"
readonly SRC_DIR="${TOP_DIR}/src"

# shellcheck disable=SC2155
readonly MAKE_JOBS_OPTIONS="-j$(nproc)"

mkdir -p "${TOP_DIR}"
mkdir -p "${BIN_DIR}"

func::install_hs() {
  if [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm curl gcc gmp make ncurses coreutils xz
  fi

  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org |
    sed 's/read -r answer <\/dev\/tty//g' |
    sed 's/read -r next_answer <\/dev\/tty/next_answer=No/g' |
    sed 's/read -r hls_answer <\/dev\/tty/hls_answer=YES/g' |
    sed 's/read -r stack_answer <\/dev\/tty/stack_answer=YES/g' |
    sh
}

func::install_neovim-from-source() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    # Build from source
    ${SUDO} apt install -y ninja-build gettext libtool libtool-bin autoconf \
      automake cmake g++ pkg-config unzip build-essential git
  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
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
  # git checkout nightly
  git checkout v0.8.0

  local -r make_opts=("${MAKE_JOBS_OPTIONS}" "CMAKE_BUILD_TYPE=Release" "CMAKE_INSTALL_PREFIX=${HOME}/usr")
  make "${make_opts[@]}"
  make "${make_opts[@]}" install
}

func::install_pyenv() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    ${SUDO} apt install -y \
      build-essential libncursesw5-dev libgdbm-dev libc6-dev zlib1g-dev \
      libsqlite3-dev tk-dev libssl-dev openssl libffi-dev libbz2-dev \
      libreadline-dev liblzma-dev lzma
    if [[ "${TARGET_PLATFORM}" == "linux-ubuntu-focal" ]]; then
      ${SUDO} apt install -y python3-dev python3-setuptools python3-pip python3-smbus
    elif [[ "${TARGET_PLATFORM}" == "linux-ubuntu-jammy" ]]; then
      ${SUDO} apt install -y python-is-python3 python3-dev python3-setuptools \
        python3-pip python3-smbus
    fi
  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm base-devel curl ncurses gdbm zlib sqlite3 \
      tk openssl libffi readline
  fi

  curl https://pyenv.run | bash

  export PATH="${HOME}/.pyenv/bin:${PATH}"
  if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
  fi

  if [[ "${TARGET_PLATFORM}" =~ linux* ]]; then
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

func::install_goenv() {
  git clone https://github.com/syndbg/goenv.git ~/.goenv

  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"

  goenv install "${GOENV_GO_VERSION}"
  goenv global "${GOENV_GO_VERSION}"

  go install golang.org/x/tools/gopls@latest
  go install github.com/mgechev/revive@latest
  go install mvdan.cc/gofumpt@latest
}

func::install_docker() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    curl -sSL https://get.docker.com | ${SUDO} sh
    ${SUDO} systemctl enable docker || true
    ${SUDO} systemctl start docker || true
  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm docker

    local exit_status=0
    systemctl >/dev/null 2>&1 || exit_status=$?
    if [[ "${exit_status}" == "0" ]]; then
      ${SUDO} systemctl enable docker
      ${SUDO} systemctl start docker
    fi
  else
    echo "Please install docker package directly."
  fi

  if [[ "${TARGET_PLATFORM}" =~ linux* ]]; then
    if [[ -n ${USER} ]] && [[ "${USER}" != "root" ]]; then
      ${SUDO} usermod -aG docker "${USER}"
    fi
  fi
}

func::install_tmux-mem-cpu-load() {
  if [[ "${TARGET_PLATFORM}" =~ linux* ]]; then
    local -r src_dir=${HOME}/usr/src/tmux-mem-cpu-load

    mkdir -p "${HOME}/usr/rc"
    rm -rf "${src_dir}"

    git clone https://github.com/thewtex/tmux-mem-cpu-load/ "${src_dir}"
    cd "${src_dir}"
    cmake . -DCMAKE_INSTALL_PREFIX="${HOME}/usr"
    # shellcheck disable=SC2046
    make -j$(nproc)
    make install
  else
    brew install tmux-mem-cpu-load
  fi
}

func::install_docker-binary() {
  if [[ "${TARGET_PLATFORM}" =~ linux* ]]; then
    local -r docker_version=${DOCKER_BINARY_VERSION_LINUX}
    local -r platform="linux"
  else
    local -r docker_version=${DOCKER_BINARY_VERSION_DARWIN}
    local -r platform="mac"
  fi

  local -r bin_file="docker_${docker_version}.tgz"
  local -r download_url=https://download.docker.com/${platform}/static/stable/x86_64/docker-${DOCKER_BINARY_VERSION_LINUX}.tgz

  func::help::create_tmp_work_dir

  curl -s -L ${download_url} -o ${bin_file}
  tar xf ${bin_file}
  mv docker/* "${BIN_DIR}"

  func::help::clean_tmp_work_dir
}

func::install_neovim-bob() {
  if [[ "${TARGET_PLATFORM}" =~ linux* ]]; then
    local -r platform="linux"
  else
    local -r platform="macos"
  fi
  func::help::create_tmp_work_dir

  local -r dowload_url="https://github.com/MordechaiHadad/bob/releases/download/v1.2.0/bob-${platform}-x86_64.zip"
  curl -s -L "${dowload_url}" -o bob-x86_64.zip
  unzip bob-x86_64.zip
  chmod +x bob
  mv bob "${BIN_DIR}"
  mkdir -p ~/.local/share/bob
  "${BIN_DIR}/bob" install nightly
  "${BIN_DIR}/bob" use nightly


  func::help::clean_tmp_work_dir
}


func::install_nvm() {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash

  export NVM_DIR="${HOME}/.nvm"
  # shellcheck disable=SC1091
  [ -f "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"

  nvm install --lts

  func::install_nvm-pkgs
}

func::install_nvm-pkgs() {
  npm install -g purescript spago parcel
  npm outdated -g || true
  npm update -g
}

func::install_ripgrep() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    wget -q "https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}_amd64.deb"
    ${SUDO} dpkg -i ./ripgrep_*_amd64.deb
    rm -rf ./ripgrep_*_amd64.deb
  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm ripgrep
  else
    brew install ripgrep
  fi
}

func::install_watchexec() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    wget -q "https://github.com/watchexec/watchexec/releases/download/cli-v${WATCHEXEC_VERSION}/watchexec-${WATCHEXEC_VERSION}-x86_64-unknown-linux-gnu.deb"
    ${SUDO} dpkg -i ./watchexec*-gnu.deb
    rm -rf ./watchexec*-gnu.deb
  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm watchexec
  else
    brew install watchexec
  fi
}

func::install_gh() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    wget -q "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.deb"
    ${SUDO} dpkg -i ./gh*amd64.deb
    rm -rf ./gh*amd64.deb
  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm gh
  else
    brew install gh
  fi
}

func::install_rust() {
  if [[ ! -f "${HOME}/.cargo/bin/rustup" ]]; then
    local -r install_script="/tmp/rustup_install.sh"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs >"${install_script}"
    chmod +x ${install_script}

    ${install_script} -y
    rm -rf ${install_script}

    export PATH="${HOME}/.cargo/bin:${PATH}"
  fi

  # Install rustfmt
  rustup component add rustfmt

  # Install rust-analyzer
  func::install_rust-analyzer
  func::install_rust-cli-tools
}

func::install_rust-analyzer() {
  if [[ "${TARGET_PLATFORM}" == "linux*" ]]; then
    local -r platform="x86_64-unknown-linux"
  else
    local -r platform="x86_64-apple-darwin"
  fi
  local -r download_url="https://github.com/rust-analyzer/rust-analyzer/releases/download/${RUST_ANALYZER_VERSION}/rust-analyzer-${platform}.gz"
  local -r rust_analyzer_bin="${BIN_DIR}/rust-analyzer"
  local -r rust_analyzer_gz="${BIN_DIR}/rust-analyzer.gz"
  rm -rf "${rust_analyzer_gz}" "${rust_analyzer_bin}"
  curl -s -L "${download_url}" -o "${rust_analyzer_gz}"
  (
    cd "${BIN_DIR}"
    gunzip rust-analyzer.gz
  )
  chmod +x "${rust_analyzer_bin}"
}

func::install_rust-cli-tools() {
  rustup update stable

  cargo install git-delta
  cargo install watchexec-cli
  cargo install bat
  cargo install fd-find
  cargo install bottom
  cargo install du-dust
  cargo install bob-nvim
}

func::install_protoc() {
  if [[ "${TARGET_PLATFORM}" =~ linux* ]]; then
    mkdir -p "${TOP_DIR}/src"
    cd "${TOP_DIR}/src"

    rm -rf "protobuf-${PROTOCOL_BUF_VERSION}" "v${PROTOCOL_BUF_VERSION}.tar.gz"

    wget -q "https://github.com/protocolbuffers/protobuf/archive/v${PROTOCOL_BUF_VERSION}.tar.gz"
    tar xf "v${PROTOCOL_BUF_VERSION}.tar.gz"
    cd "protobuf-${PROTOCOL_BUF_VERSION}"
    ./autogen.sh
    ./configure --prefix="${TOP_DIR}"
    make "${MAKE_JOBS_OPTIONS}"
    make install
  else
    brew install protobuf
  fi
}

func::install_mosh() {
  func::install_protoc

  if [[ "${TARGET_PLATFORM}" =~ linux* ]]; then
    export PKG_CONFIG_PATH=${TOP_DIR}/lib/pkgconfig
  fi

  mkdir -p "${TOP_DIR}/src"
  cd "${TOP_DIR}/src"
  rm -rf mosh
  git clone https://github.com/mobile-shell/mosh
  cd mosh
  ./autogen.sh
  ./configure --prefix="${TOP_DIR}"
  make "${MAKE_JOBS_OPTIONS}"
  make install
}

func::install_alactirry() {
  if [[ "${TARGET_PLATFORM}" =~ linux* ]]; then
    func::help::create_tmp_work_dir

    git clone https://github.com/alacritty/alacritty
    cd alacritty
    git checkout v0.11.0

    cargo build --release

    sudo cp target/release/alacritty /usr/local/bin
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database

    func::help::clean_tmp_work_dir
  fi
}

func::install_sublimetext() {
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  sudo apt-get install apt-transport-https
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  sudo apt-get update
  sudo apt-get install -y sublime-text
}

func::install_env() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    ${SUDO} apt update
    ${SUDO} apt upgrade -y
    ${SUDO} apt install -y python3 cscope curl wget zsh tmux neovim \
      git tig silversearcher-ag htop unzip cmake \
      build-essential jq tree inotify-tools net-tools \
      iproute2 bridge-utils psmisc tmuxinator \
      pigz pbzip2 p7zip-full p7zip-rar \
      screenfetch ansiweather ccache shellcheck ncdu \
      libnotify-bin libgmp-dev \
      autoconf libtool flex bison
    if [[ "${TARGET_PLATFORM}" == "linux-ubuntu-jammy" ]]; then
      ${SUDO} apt install -y universal-ctags
    fi

    # Install latest git
    ${SUDO} add-apt-repository ppa:git-core/ppa
    ${SUDO} apt update
    ${SUDO} apt install -y git
  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    ${SUDO} pacman -Syu --noconfirm
    ${SUDO} pacman -S --noconfirm coreutils python3 ctags cscope curl wget zsh \
      tmux neovim git tig htop unzip the_silver_searcher \
      base-devel jq tree inotify-tools net-tools bc llvm clang cmake \
      iproute2 bridge-utils psmisc inetutils \
      pigz pbzip2 p7zip xz \
      screenfetch ccache
  else
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

func::install_all() {
  for package in ${LIST_PACKAGES}; do
    func::install_package "${package}"
  done
}

func::determine_target_platform() {
  if [[ "${PLATFORM}" != "darwin" ]]; then
    local -r linux_distro=$(grep "^ID" /etc/os-release | head -n1 | awk -F'=' '{print $2}')
    if [[ "${linux_distro}" == "ubuntu" ]] || [[ "${linux_distro}" == "pop" ]]; then
      local -r version_num=$(grep VERSION /etc/os-release | head -n1 | awk -F'=' '{print $2}' | sed 's/"//g' | awk '{print $1}')
      if [[ "${version_num}" =~ 20.04* ]]; then
        TARGET_PLATFORM="linux-ubuntu-focal"
      elif [[ "${version_num}" =~ 22.04* ]]; then
        TARGET_PLATFORM="linux-ubuntu-jammy"
      else
        echo "Unsupported for the ubuntu version ${version_num}"
      fi
    elif [[ "${linux_distro}" == "arch" ]]; then
      TARGET_PLATFORM="linux-arch"
    fi
  fi
}

func::determine_target_platform
for args in "$@"; do
  # shellcheck disable=SC2086
  func::install_package $args
done
