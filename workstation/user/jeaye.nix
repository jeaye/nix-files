{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    pinentry
    gnupg
  ];
}
