{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    ## Vim
    vimHugeX
    vimPlugins.YouCompleteMe

    ## Browsing/downloading
    wget
    elinks

    ## File formats
    unzip
    file

    ## Networking
    telnet
    traceroute
    sshfs

    ## Source control
    git

    ## Shell
    htop
    bashCompletion
    nix-repl
    tmux
  ];
}
