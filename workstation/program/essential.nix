{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    ## Vim
    vimHugeX
    vimPlugins.YouCompleteMe # TODO: For only certain languages?

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
    rxvt_unicode
  ];
}
