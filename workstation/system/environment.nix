{ config, pkgs, ... }:

# TODO: Remove this file and move these options elsewhere
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
