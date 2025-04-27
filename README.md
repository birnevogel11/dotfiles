#  Personal dotfiles

The config is only for personal usage. It does not guarantee to work in your
environment. The default install path is `${HOME}/usr/rc`

## Install

```bash
mkdir -p $HOME/usr
cd $HOME/usr
git clone https://github.com/birnevogel11/dotfiles $HOME/usr/rc
cd ${HOME}/usr/rc
./install.sh
```

## Install software/packages manually

### Docker

  ```bash
  curl -sSL https://get.docker.com | sudo sh
  usermod -aG docker $USER
  ```
