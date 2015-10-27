{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox
    elinks
  ];
}
