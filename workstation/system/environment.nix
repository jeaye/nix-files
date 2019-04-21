{ config, pkgs, ... }:

# TODO: Remove this file and move these options elsewhere
{
  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;
}
