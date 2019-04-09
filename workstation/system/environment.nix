{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;
}
