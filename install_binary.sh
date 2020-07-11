#!/usr/bin/env bash

# The script is only tested in Ubuntu bionic/focal and macOS 10.14.

set -ex

if [[ "${UID}" == "0" ]]; then
  SUDO=""
else
  SUDO="sudo"
fi

PLATFORM=$(uname)
readonly PLATFORM=$(echo "${PLATFORM}" | tr '[:upper:]' '[:lower:]')
if [[ "${PLATFORM}" == "darwin" ]]; then
  if [[ "$(sw_vers | grep ProductVersion | awk '{print $2}')" == "10.14*" ]]; then
    readonly MACOS_VERSION="10.14"
  fi
fi
TARGET_PLATFORM="${PLATFORM}"

readonly LIST_PACKAGES="env ccls-from-source neovim-from-source \
  docker-compose ctop gotop skim fd exa ripgrep watchexec \
  pyenv diff-so-fancy docker-binary docker rust go hs"
readonly CTOP_VERSION=0.7.3
readonly DOCKER_BINARY_VERSION_DARWIN=19.03.9
readonly DOCKER_BINARY_VERSION_LINUX=19.03.12
readonly DOCKER_COMPOSE_VERSION=1.24.1
readonly EXA_VERSION=0.9.0
readonly FD_VERSION=8.1.1
readonly GOTOP_VERSION=3.5.3
readonly GO_VERSION=1.14.2
readonly LF_VERSION=r14
readonly LLVM_VERSION=10
readonly NEOVIM_FROM_SOURCE_VERSION=nightly
readonly PYENV_PYTHON3_VERSION=3.8.3
readonly RIPGREP_VERSION=11.0.2
readonly RUST_ANALYZER_VERSION=2020-06-15
readonly SKIM_VERSION=0.8.2
readonly WATCHEXEC_VERSION=1.14.0

# Haskell
readonly GHC_VERSION=8.8.3
readonly CABAL_VERSION=3.2.0.0

readonly TOP_DIR=${HOME}/usr
readonly BIN_DIR=${TOP_DIR}/bin
readonly SRC_DIR=${TOP_DIR}/src
readonly HS_DIR=${TOP_DIR}/tools/hs

readonly MAKE_JOBS_OPTIONS="-j$(nproc)"

mkdir -p "${TOP_DIR}"
mkdir -p "${BIN_DIR}"

func::install_hs-ghc() {
  case "${TARGET_PLATFORM}" in
    darwin)
      local -r platform="apple-darwin"
      ;;
    linux-ubuntu-bionic)
      local -r platform="deb9-linux"
      ;;
    *)
    local -r platform="deb10-linux"
    ;;
  esac

  local -r download_url="https://downloads.haskell.org/~ghc/${GHC_VERSION}/ghc-${GHC_VERSION}-x86_64-${platform}.tar.xz"
  local -r bin_file="ghc-install.tar.xz"

  func::help::create_tmp_work_dir

  curl -s -L ${download_url} -o ${bin_file}
  tar xf ${bin_file}

  cd ghc-${GHC_VERSION}
  ./configure --prefix="${HS_DIR}"
  make ${MAKE_JOBS_OPTIONS} install

  func::help::clean_tmp_work_dir
}

func::install_hs-cabal() {
  case "${TARGET_PLATFORM}" in
    linux*)
      local -r platform="unknown-linux"
      ;;
    darwin)
      local -r platform="apple-darwin17.7.0"
      ;;
  esac

  local -r download_url="https://downloads.haskell.org/~cabal/cabal-install-${CABAL_VERSION}/cabal-install-${CABAL_VERSION}-x86_64-${platform}.tar.xz"
  local -r bin_file="cabal-install.tar.xz"

  func::help::create_tmp_work_dir

  curl -s -L ${download_url} -o ${bin_file}
  tar xf ${bin_file}

  mkdir -p ${HS_DIR}/bin

  rm -rf "${HS_DIR}/bin/cabal"
  mv cabal ${BIN_DIR}

  func::help::clean_tmp_work_dir
}

func::install_hs-stack() {
  local -r install_script="/tmp/install_hs_stack.sh"
  curl -sSL https://get.haskellstack.org/ > ${install_script}
  chmod +x ${install_script}

  mkdir -p ${HS_DIR}/bin

  if [[ -f ${HS_DIR}/bin/stack ]]; then
    rm -rf ${HS_DIR}/bin/stack
  fi
  ${install_script} -d ${HS_DIR}/bin

  rm -rf ${install_script}
}

func::install_hs() {
  rm -rf ${HS_DIR}

  mkdir -p ${HS_DIR}
  mkdir -p ${HS_DIR}/bin

  func::install_hs-ghc
  func::install_hs-cabal
  func::install_hs-stack
}

func::install_docker-compose() {
  if [[ "${TARGET_PLATFORM}" =~ linux* ]]; then
    curl -s -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-"$(uname -s)"-"$(uname -m)" -o "${BIN_DIR}/docker-compose" && chmod +x "${BIN_DIR}/docker-compose"
  else
    brew install docker-compose docker-compose-completion
  fi
}

func::install_ctop() {
  if [[ "${TARGET_PLATFORM}" =~ linux* ]]; then
    curl -s -L "https://github.com/bcicen/ctop/releases/download/v${CTOP_VERSION}/ctop-${CTOP_VERSION}-${PLATFORM}-amd64" -o "${BIN_DIR}/ctop" && chmod +x "${BIN_DIR}/ctop"
  else
    brew install ctop
  fi
}

func::install_gotop() {
  if [[ "${TARGET_PLATFORM}" =~ linux* ]]; then
    local -r download_url="https://github.com/xxxserxxx/gotop/releases/download/v${GOTOP_VERSION}/gotop_v${GOTOP_VERSION}_linux_amd64.tgz"
    local -r bin_file="gotop_v${GOTOP_VERSION}_linux_amd64.tgz"
    func::help::create_tmp_work_dir

    curl -s -L ${download_url} -o ${bin_file}
    tar xf ${bin_file}
    mv gotop "${BIN_DIR}"

    func::help::clean_tmp_work_dir
  else
    brew install gotop
  fi
}

func::install_go() {
  export GOPATH=${HOME}/Trek/go
  local go_tarball_name="go${GO_VERSION}.${PLATFORM}-amd64.tar.gz"

  # Install go binary
  cd "${TOP_DIR}"
  curl -s -L "https://dl.google.com/go/${go_tarball_name}" -o "${go_tarball_name}"
  tar xf "${go_tarball_name}"
  rm "${go_tarball_name}"

  # Set path
  mkdir -p "${GOPATH}"
  mkdir -p "${GOPATH}/bin"
  export PATH=${GOPATH}/bin:${HOME}/usr/go/bin:${PATH}

  # Install dep
  if [[ "${TARGET_PLATFORM}" =~ linux* ]]; then
    curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
  else
    brew install dep
  fi
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
  git checkout ${NEOVIM_FROM_SOURCE_VERSION}

  local -r make_option="${MAKE_JOBS_OPTIONS} CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=${HOME}/usr"
  make ${make_option}
  make ${make_option} install
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
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
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

func::install_diff-so-fancy() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    curl -L https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -o "${BIN_DIR}/diff-so-fancy" -o "${BIN_DIR}/diff-so-fancy" && chmod +x "${BIN_DIR}/diff-so-fancy"
  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm diff-so-fancy
  else
    brew install diff-so-fancy
  fi
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

func::install_llvm() {
  if [[ "${TARGET_PLATFORM}" == "linux-ubuntu-focal" ]]; then
    ${SUDO} apt install -y build-essential cmake zlib1g-dev libncurses-dev \
      llvm clang llvm-dev libclang-dev
  elif [[ "${TARGET_PLATFORM}" == "linux-ubuntu-bionic" ]]; then
    ${SUDO} apt install -y build-essential cmake zlib1g-dev libncurses-dev wget

    local -r download_script="/tmp/llvm.sh"
    ${SUDO} apt install -y lsb-release software-properties-common
    wget -q -O ${download_script} https://apt.llvm.org/llvm.sh
    chmod +x ${download_script}
    ${SUDO} ${download_script} ${LLVM_VERSION}
    rm -rf ${download_script}

    ${SUDO} apt install -y clang-format-${LLVM_VERSION} \
      clang-tidy-${LLVM_VERSION} libclang-${LLVM_VERSION}-dev

  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm llvm clang z3
  elif [[ "${TARGET_PLATFORM}" == "darwin" ]]; then
    brew install llvm

    ln -sf /usr/locak/opt/llvm/bin/clang-format "${BIN_DIR}/clang-format"
    ln -sf /usr/local/opt/llvm/bin/clang-tidy "${BIN_DIR}/clang-tidy"
  fi
}

func::install_ccls-from-source() {
  local -r ccls_llvm_version=10
  local -r src_dir="${SRC_DIR}/ccls"
  rm -rf "${src_dir}"

  func::install_llvm

  if [[ "${TARGET_PLATFORM}" == "linux-ubuntu-bionic" ]]; then
    [[ ! -f /usr/bin/clang ]] && ${SUDO} ln -sf /usr/bin/clang-${LLVM_VERSION} /usr/bin/clang
  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    local -r llvm_dir="${HOME}/usr/tools/llvm"

    ${SUDO} pacman -S --noconfirm base-devel cmake zlib ncurses z3 curl wget

    local -r tarball_name="clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz"
    local -r folder_name="clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04"
    ( cd "${TOP_DIR}" \
      && mkdir -p src "${TOP_DIR}/tools" \
      && cd "${TOP_DIR}/src" \
      && wget -q "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz" \
      && tar xf "${tarball_name}" \
      && mv "${folder_name}" "${llvm_dir}" \
      && rm -rf "${tarball_name}"
    )

    [[ ! -f "/usr/lib/libtinfo.so.5" ]] &&  ${SUDO} ln -sf /usr/lib/libtinfo.so.6 /usr/lib/libtinfo.so.5
  fi

  if [[ "${TARGET_PLATFORM}" == linux-ubuntu-focal ]]; then
    local -r ccls_cc=/usr/bin/clang
    local -r ccls_cxx=/usr/bin/clang++
    local -r cmake_prefix_path=/usr
    local -r llvm_include_dir=/usr/include/llvm
  elif [[ "${TARGET_PLATFORM}" == linux-ubuntu-bionic ]]; then
    local -r ccls_cc=/usr/lib/llvm-${ccls_llvm_version}/bin/clang
    local -r ccls_cxx=/usr/lib/llvm-${ccls_llvm_version}/bin/clang++
    local -r cmake_prefix_path=/usr
    local -r llvm_include_dir=/usr/include/llvm-${ccls_llvm_version}
  elif [[ "${TARGET_PLATFORM}" == linux-arch ]]; then
    local -r ccls_cc=/usr/bin/clang
    local -r ccls_cxx=/usr/bin/clang++
    local -r cmake_prefix_path=${llvm_dir}
    local -r llvm_include_dir=${llvm_dir}/include/llvm
  elif [[ "${TARGET_PLATFORM}" == "darwin" ]]; then
    if [[ "${ccls_llvm_version}" != "${LLVM_VERSION}" ]]; then
      local -r llvm_prefix=/usr/local/opt/llvm@${ccls_llvm_version}
    else
      local -r llvm_prefix=/usr/local/opt/llvm
    fi
    local -r ccls_cc=/usr/bin/clang
    local -r ccls_cxx=/usr/bin/clang++
    local -r cmake_prefix_path=${llvm_prefix}
    local -r llvm_include_dir=${llvm_prefix}/include
  fi

  git clone --recursive https://github.com/MaskRay/ccls "${src_dir}"
  cd "${src_dir}"
  CC="${ccls_cc}" CXX="${ccls_cxx}" cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=${cmake_prefix_path} \
    -DLLVM_INCLUDE_DIR=${llvm_include_dir} \
    -DCMAKE_INSTALL_PREFIX="${HOME}/usr"
  cd "${src_dir}/Release"
  make ${MAKE_JOBS_OPTIONS}
  make install
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
  mv docker/* ${BIN_DIR}

  func::help::clean_tmp_work_dir
}

func::install_lf() {
  if [[ "${TARGET_PLATFORM}" =~ linux* ]]; then
    local -r bin_file="lf-linux-amd64.tar.gz"
    local -r download_url="https://github.com/gokcehan/lf/releases/download/${LF_VERSION}/lf-linux-amd64.tar.gz"

    func::help::create_tmp_work_dir

    curl -s -L ${download_url} -o ${bin_file}
    tar xf ${bin_file}
    mv lf "${BIN_DIR}"

    func::help::clean_tmp_work_dir
  else
    brew install lf
  fi
}

func::install_sublime-merge() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    if hash gnome-shell 2>/dev/null; then
      ${SUDO} apt install -y apt-transport-https
      wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
      echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
      ${SUDO} apt update
      ${SUDO} apt install sublime-merge
    fi
  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    # TODO: support for linux-arch
    echo "TODO: support for linux-arch"
  else
    echo "Please install dmg directly."
  fi
}

func::install_ripgrep() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    wget -q https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}_amd64.deb
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
  if [[ "${TARGET_PLATFORM}" == "linux*" ]]; then
    local -r platform="linux"
  else
    local -r platform="mac"
  fi
  local -r download_url="https://github.com/rust-analyzer/rust-analyzer/releases/download/${RUST_ANALYZER_VERSION}/rust-analyzer-${platform}"
  local -r rust_analyzer_bin="${BIN_DIR}/rust-analyzer"
  rm -rf ${rust_analyzer_bin}
  curl -s -L ${download_url} -o ${rust_analyzer_bin}
  chmod +x ${rust_analyzer_bin}
}

func::install_skim() {
  if [[ "${TARGET_PLATFORM}" == "darwin" ]]; then
    brew install sk
  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm skim
  elif [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    local -r download_url="https://github.com/lotabout/skim/releases/download/v${SKIM_VERSION}/skim-v${SKIM_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
    local -r bin_file="skim-v${SKIM_VERSION}-x86_64-unknown-linux-gnu.tar.gz"

    func::help::create_tmp_work_dir

    curl -s -L ${download_url} -o ${bin_file}
    tar xf ${bin_file}
    mv sk "${BIN_DIR}"

    func::help::clean_tmp_work_dir
  fi

  # Download shell config
  mkdir -p ${HOME}/.config
  rm -rf ${HOME}/.config/skim
  git clone --depth 1 https://github.com/lotabout/skim ${HOME}/.config/skim

  if [[ "${TARGET_PLATFORM}" =~ linux-ubutnu* ]]; then
    cp ${HOME}/.config/skim/bin/sk-tmux ${BIN_DIR}/sk-tmux
    chmod +x ${BIN_DIR}/sk-tmux
  fi
}

func::install_fd() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    local -r dpkg_download_url="https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd_${FD_VERSION}_amd64.deb"
    local -r dpkg_path="/tmp/fd_${FD_VERSION}_amd64.deb"

    rm -rf ${dpkg_path}
    wget -q ${dpkg_download_url} -O ${dpkg_path}
    ${SUDO} dpkg -i ${dpkg_path}
    rm -rf ${dpkg_path}
  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm fd
  elif [[ "${TARGET_PLATFORM}" == "darwin" ]]; then
    brew install fd
  fi
}

func::install_watchexec() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    local -r
    download_url="https://github.com/watchexec/watchexec/releases/download/${WATCHEXEC_VERSION}/watchexec-${WATCHEXEC_VERSION}-x86_64-unknown-linux-gnu.deb"
    local -r download_file="watchexec-${WATCHEXEC_VERSION}-x86_64-unknown-linux-gnu.deb"

    func::create_tmp_work_dir

    rm -f "${download_file}"
    wget -q "${download_url}" -O "${download_file}"
    ${SUDO} dpkg -i ${download_file}
    rm -f "${download_file}"

    func::clean_tmp_work_dir

  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    ${SUDO} pacman -S --noconfirm watchexec
  elif [[ "${TARGET_PLATFORM}" == "darwin" ]]; then
    brew install watchexec
  fi
}

func::install_exa() {
  if [[ "${TARGET_PLATFORM}" =~ linux* ]]; then
    local -r download_url="https://github.com/ogham/exa/releases/download/v${EXA_VERSION}/exa-linux-x86_64-${EXA_VERSION}.zip"
    local -r bin_file="exa-linux-x86_64-${EXA_VERSION}.zip"

    func::help::create_tmp_work_dir

    curl -s -L ${download_url} -o ${bin_file}
    unzip ${bin_file}
    mv exa-linux-x86_64 "${BIN_DIR}/exa"
    chmod +x ${BIN_DIR}/exa

    func::help::clean_tmp_work_dir
  elif [[ "${TARGET_PLATFORM}" == "darwin" ]]; then
    brew install exa
  fi
}

func::install_env() {
  if [[ "${TARGET_PLATFORM}" =~ linux-ubuntu* ]]; then
    ${SUDO} apt update
    ${SUDO} apt upgrade -y
    ${SUDO} apt install -y python3 ctags cscope curl wget zsh tmux vim \
                        git tig silversearcher-ag htop unzip \
                        build-essential jq tree inotify-tools net-tools \
                        iproute2 bridge-utils psmisc tmuxinator \
                        pigz pbzip2 p7zip-full p7zip-rar \
                        screenfetch ansiweather ccache
  elif [[ "${TARGET_PLATFORM}" == "linux-arch" ]]; then
    ${SUDO} pacman -Syu --noconfirm
    ${SUDO} pacman -S --noconfirm python3 ctags cscope curl wget zsh tmux \
      neovim git tig htop unzip the_silver_searcher \
      base-devel jq tree inotify-tools net-tools bc llvm clang \
      iproute2 bridge-utils psmisc \
      pigz pbzip2 p7zip \
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
                 fswatch make gnu-tar gnu-time gnu-which gnu-sed \
                 coreutils iproute2mac tmuxinator shellcheck fd \
                 screenfetch weather ccache
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
    if [[ "${linux_distro}" == "ubuntu" ]]; then
      local -r version_num=$(grep VERSION /etc/os-release | head -n1 | awk -F'=' '{print $2}' | sed 's/"//g' | awk '{print $1}')
      if [[ "${version_num}" == "20.04" ]]; then
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
  func::install_package $args
done
