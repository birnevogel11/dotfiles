# Yen3's vimrc

* The setting is only for neovim.

* Install neovim (for macOS and ubuntu)

```
curl -q https://gitlab.com/yen3/dotfiles/raw/master/install_binary.sh | bash -s neovim
```

* Install vimfiles

If you want to install the repo without yen3/dotfiles indiviually. Here's
example way. (Assume the install path is `${HOME}/usr/rc/vim`)

```
mkdir -p ${HOME}/usr/rc
cd ${HOME}/usr/rc
git clone https://gitlab.com/yen3/vimfiles vim
cd ${HOME}/usr/rc/vim
./install_vim.sh
```
