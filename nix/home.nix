{ config, pkgs, ... }:

let
  inherit (pkgs) stdenv;
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "yen3";
  home.homeDirectory = if stdenv.isDarwin then "/Users/yen3" else "/home/yen3";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Packages to install
  home.packages = [
    pkgs.niv
    pkgs.nox
    pkgs.direnv

    pkgs.bat
    pkgs.docker-ls
    pkgs.ctop
    pkgs.delta
    pkgs.fzy
    pkgs.duf
    pkgs.exa
    pkgs.fd
    pkgs.gh
    pkgs.gitui
    pkgs.gotop
    pkgs.lf
    pkgs.ripgrep
    pkgs.shellcheck
    pkgs.tree
    pkgs.watchexec
    pkgs.jq
    pkgs.fzf
    pkgs.yt-dlp
    pkgs.shfmt
    pkgs.cloc

    pkgs.tmux
    pkgs.tmate

    pkgs.sshuttle
    pkgs.pigz
    pkgs.wget
    pkgs.universal-ctags
    pkgs.neovim
    pkgs.git
    pkgs.htop
    pkgs.tree-sitter
    pkgs.sqlite
    pkgs.rsync
    pkgs.ccache
    pkgs.docker-compose
    pkgs.curl
    pkgs.cmake
    pkgs.pkg-config
    pkgs.autoconf
    pkgs.automake
    pkgs.python3
    # pkgs.progress
    # pkgs.unrar

    pkgs.coreutils-full
    pkgs.ffmpeg
    pkgs.gnugrep
    pkgs.gnupg
    pkgs.gnused
    pkgs.httpie
    pkgs.neofetch
    pkgs.nix
    pkgs.nixfmt
    pkgs.nixpkgs-fmt
    pkgs.openssh
    pkgs.poetry
    pkgs.ripgrep-all
    pkgs.vagrant

    pkgs.ghc
    pkgs.haskell-language-server
    pkgs.stack
  ];
}
