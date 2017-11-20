{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs;
  [
    ## Security
    pinentry
    gnupg
  ];
}
