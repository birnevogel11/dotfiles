# Yen3's dotfiles

## Recommand install path

* `$HOME/usr/rc`

## Install

```bash
mkdir -p $HOME/usr
cd $HOME/usr
git clone --recursive https://gitlab.com/yen3/dotfiles $HOME/usr/rc
cd ${HOME}/usr/rc && ./install.sh
```

## Install software/packages manually

* Prerequest packages - `curl -q https://gitlab.com/yen3/dotfiles/raw/master/install_binary.sh | bash -s env`
* Neovim -  `curl -q https://gitlab.com/yen3/dotfiles/raw/master/install_binary.sh | bash -s neovim`

### Docker

    curl -sSL https://get.docker.com | sudo sh
    usermod -aG docker $USER

### Pyenv

* Ubuntu package memo ([ref](https://stackoverflow.com/questions/27022373/python3-importerror-no-module-named-ctypes-when-using-value-from-module-mul))

    ```
    sudo apt install -y \
        build-essential \
        python3-dev \
        python3-setuptools \
        python3-pip \
        python3-smbus  \
        libncursesw5-dev \
        libgdbm-dev \
        libc6-dev  \
        zlib1g-dev  \
        libsqlite3-dev  \
        tk-dev  \
        libssl-dev  \
        openssl  \
        libffi-dev \
        libbz2-dev \
        libreadline-dev
    ```

* Install command memo

    ```
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    ```

* Install python through pyenv

    ```
    pyenv install 3.7.0
    pyenv global 3.7.0

    pip install pynvim black flake8 ipython
    ```

* Install python through pyenv in macOS 10.14

    ```
    SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk MACOSX_DEPLOYMENT_TARGET=10.14 pyenv install -f -v 3.8.0
    pyenv global 3.8.0

    pip install pynvim black flake8 ipython
    ```

### Install from script

* Run `./install_binary.sh` directly without downloading it

```bash
curl -q https://gitlab.com/yen3/dotfiles/raw/master/install_binary.sh | bash -s neovim-from-source
```

## Neovim local config

- ref: https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings
- Create a `.nvimrc` and put the local folder

### Customize pylsp plugins

```vim
set textwidth=120

lua << EOF
  local lsp = require('yen3.lsp')

  local local_pylsp_config = {
    configurationSources = {},
    plugins = {
      flake8      = { enabled = false },
      pylint      = { enabled = true  },
      pyls_mypy   = { enabled = true  },
      pylsp_black = { enabled = false },
      pycodestyle = { enabled = false },
      pyflakes    = { enabled = false },
      yapf        = { enabled = false },
    },
  }

  lsp.lsp_config_pylsp(local_pylsp_config, false)
EOF
```

### Enable HLS for current folder

```vim
lua << EOF
  local lsp = require('yen3.lsp')
  lsp.lsp_hls_fixed_cwd()
EOF
```
