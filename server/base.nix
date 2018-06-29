{ config, pkgs, ... }:

{
  imports =
  [
    ../shared/configuration.nix

    ## System
    ./system/environment.nix
    ./system/network.nix
    ./system/security.nix

    ## Global programs
    ./program/essential.nix

    ## Users
    ./system/user.nix
  ];
}
