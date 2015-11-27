{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vimHugeX
    python2
    python3
    vimPlugins.YouCompleteMe
  ];
}
