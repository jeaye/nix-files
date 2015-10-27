{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cmus
    mplayer
    transmission_gtk
  ];
}
