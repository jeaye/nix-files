{ config, pkgs, ... }:

{
  environment.systemPackages = let pkgsUnstable = import
  (
    fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz
  )
  { };
  in
  with pkgs;
  [
    ## Vim
    neovim
    tree-sitter
    fzf
    silver-searcher
    ripgrep

    ## Browsing/downloading
    wget

    ## Reading
    pkgsUnstable.koodo-reader

    ## File formats
    unzip
    file

    ## Networking
    traceroute
    sshfs

    ## Source control
    git

    ## Shell
    tmux
    # 0.13.0 migrated to toml
    pkgsUnstable.alacritty
    starship
    pcre

    ## Administration
    htop
    psmisc
    lm_sensors

    # Hardware
    uhk-agent
  ];

  hardware.keyboard.uhk.enable = true;
}
