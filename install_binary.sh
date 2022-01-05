#!/usr/bin/env bash

# The script is only tested in Ubuntu bionic/focal and macOS 10.14.
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

readonly LIST_PACKAGES="env neovim-from-source pyenv docker-binary docker hs nvm"
readonly DOCKER_BINARY_VERSION_DARWIN=20.10.7
readonly DOCKER_BINARY_VERSION_LINUX=20.10.7
readonly PYENV_PYTHON3_VERSION=3.9.6
readonly RUST_ANALYZER_VERSION=2021-07-05
readonly PROTOCOL_BUF_VERSION=3.17.3

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

  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org  | \
    sed 's/read -r answer <\/dev\/tty//g' | \
    sed 's/read -r next_answer <\/dev\/tty/next_answer=No/g' | \
    sed 's/read -r hls_answer <\/dev\/tty/hls_answer=YES/g'| \
    sed 's/read -r stack_answer <\/dev\/tty/stack_answer=YES/g'| \
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
  git checkout v0.6.1
  # git checkout stable
  # git checkout nightly

  local -r make_opts=("${MAKE_JOBS_OPTIONS}" "CMAKE_BUILD_TYPE=Release" "CMAKE_INSTALL_PREFIX=${HOME}/usr")
  make "${make_opts[@]}"
  make "${make_opts[@]}" install
}

func::install_pyenv() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    ${SUDO} apt install -y \
      build-essential libncursesw5-dev libgdbm-dev libc6-dev zlib1g-dev \
      libsqlite3-dev tk-dev libssl-dev openssl libffi-dev libbz2-dev \
      libreadline-dev
    if [[ "${TARGET_PLATFORM}" == "linux-ubuntu-bionic" ]]; then
      ${SUDO} apt install -y python-dev python-setuptools python-pip python-smbus
    elif [[ "${TARGET_PLATFORM}" == "linux-ubuntu-focal" ]]; then
      ${SUDO} apt install -y python3-dev python3-setuptools python3-pip python3-smbus
    fi
  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm base-devel curl ncurses gdbm zlib sqlite3 \
      tk openssl libffi readline
  fi

  curl https://pyenv.run | bash

  export PATH="${HOME}/.pyenv/bin:${PATH}"
  if command -v pyenv 1>/dev/null 2>&1
  then
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

func::install_docker() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    curl -sSL https://get.docker.com | ${SUDO} sh

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
    local -r src_dir=${HOME}/usr/rc/tmux-mem-cpu-load

    mkdir -p "${HOME}/usr/rc"
    rm -rf "${src_dir}"

    git clone https://github.com/thewtex/tmux-mem-cpu-load/ "${src_dir}"
    cd "${src_dir}"
    cmake .  -DCMAKE_INSTALL_PREFIX="${HOME}/usr"
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

func::install_nvm() {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

  export NVM_DIR="${HOME}/.nvm"
  # shellcheck disable=SC1091
  [ -f "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"

  nvm install --lts

  npm install -g eslint prettier \
    vim-language-server \
    vscode-html-languageserver-bin \
    dockerfile-language-server-nodejs \
    typescript-language-server \
    bash-language-server \
    pyright

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

func::install_rust() {
  if [[ ! -f "${HOME}/.cargo/bin/rustup" ]]; then
    local -r install_script="/tmp/rustup_install.sh"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "${install_script}"
    chmod +x ${install_script}

    ${install_script} -y
    rm -rf ${install_script}

    export PATH="${HOME}/.cargo/bin:${PATH}"
  fi

  # Install rustfmt
  rustup component add rustfmt

  # Install rust-analyzer
  func::install_rust-analyzer
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

func::install_env() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    ${SUDO} apt update
    ${SUDO} apt upgrade -y
    ${SUDO} apt install -y python3 ctags cscope curl wget zsh tmux neovim \
                        git tig silversearcher-ag htop unzip cmake \
                        build-essential jq tree inotify-tools net-tools \
                        iproute2 bridge-utils psmisc tmuxinator \
                        pigz pbzip2 p7zip-full p7zip-rar \
                        screenfetch ansiweather ccache shellcheck ncdu
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
      ${SUDO} installer -pkg ${pkg_path} -target / || true
    fi

    brew update
    brew upgrade
    brew install zsh python@2 python@3 ctags cscope curl wget tmux vim p7zip\
                 neovim git tig ag ripgrep htop jq diff-so-fancy tree pstree \
                 watchexec make gnu-tar gnu-time gnu-which gnu-sed rsync\
                 coreutils iproute2mac tmuxinator shellcheck fd \
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
    local -r linux_distro=$(grep "ID" /etc/os-release | head -n1 | awk -F'=' '{print $2}' )
    if [[ "${linux_distro}" == "ubuntu" ]] || [[ "${linux_distro}" == "pop" ]]; then
      local -r version_num=$(grep VERSION /etc/os-release | head -n1 | awk -F'=' '{print $2}' | sed 's/"//g' | awk '{print $1}')
      if [[ "${version_num}" =~ 20.04* ]]; then
        TARGET_PLATFORM="linux-ubuntu-focal"
      else
        TARGET_PLATFORM="linux-ubuntu-bionic"
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
