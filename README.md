# Yen3's dotfiles

The config is only for personal usage. It does not guarantee to work in your
environment. The default install path is `${HOME}/usr/rc`

## Install

```bash
mkdir -p $HOME/usr
cd $HOME/usr
git clone https://gitlab.com/yen3/dotfiles $HOME/usr/rc
cd ${HOME}/usr/rc
./install.sh
```

## Install software/packages manually

### Docker

  ```bash
  curl -sSL https://get.docker.com | sudo sh
  usermod -aG docker $USER
  ```

### Pyenv

- Ubuntu package memo ([ref](https://stackoverflow.com/questions/27022373/python3-importerror-no-module-named-ctypes-when-using-value-from-module-mul))

    ```bash
    sudo apt install -y \
        build-essential \
        lcov \
        libbz2-dev \
        libc6-dev  \
        libffi-dev \
        libgdbm-compat-dev \
        libgdbm-dev \
        liblzma-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev  \
        libssl-dev  \
        lzma \
        lzma-dev \
        openssl  \
        pkg-config \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-smbus  \
        tk-dev  \
        uuid-dev \
        zlib1g-dev
    ```

- Install command memo

    ```bash
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    ```

- Install python through pyenv

    ```bash
    pyenv install 3.7.0
    pyenv global 3.7.0

    pip install pynvim black flake8 ipython
    ```

- Install python through pyenv in macOS 10.14

    ```bash
    SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk MACOSX_DEPLOYMENT_TARGET=10.14 pyenv install -f -v 3.11.1
    pyenv global 3.11.1

    pip-common-packages
    ```
