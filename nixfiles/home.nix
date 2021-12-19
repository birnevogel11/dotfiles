{ config, pkgs, ... }:

let
  inherit (pkgs) stdenv;
in {
  home.username = "yen3";
  home.homeDirectory = if stdenv.isDarwin then "/Users/yen3" else "/home/yen3";

  home.stateVersion = "21.11";

  programs.home-manager.enable = true;
  programs.bat.enable = true;

  home.packages = with pkgs; [
    # Nix releated
    niv
    nox
    direnv

    # Personal command line tools
    bat
    cloc
    ctop
    delta
    docker-ls
    duf
    exa
    fd
    fzf
    fzy
    gh
    gitui
    gotop
    jq
    lf
    ripgrep-all
    shellcheck
    shfmt
    tree
    watchexec
    yt-dlp

    # Tmux
    tmux
    tmate

    # Neovim
    neovim
    nixfmt
    nixpkgs-fmt
    tree-sitter
    universal-ctags

    # System tools
    # progress
    # unrar
    autoconf
    automake
    ccache
    cmake
    coreutils-full
    curl
    docker-compose
    ffmpeg
    fontconfig
    git
    gnugrep
    gnupg
    gnused
    htop
    httpie
    neofetch
    nix
    openssh
    pigz
    pkg-config
    poetry
    python3
    rsync
    sqlite
    sshuttle
    vagrant
    wget
    zsh

    # Haskell
    # ghc
    # haskell-language-server
    # stack
  ];
}
