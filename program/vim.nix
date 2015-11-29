{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    python2
    python3
    vimPlugins.YouCompleteMe
  ];
}
