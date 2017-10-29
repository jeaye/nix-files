{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    vim
    wget
    elinks
    unzip
    git
    htop
    bashCompletion
    telnet
    traceroute
    nix-repl
    file
  ];
}
