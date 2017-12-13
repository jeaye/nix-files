{ config, pkgs, ... }:

{
  imports =
  [
    ## System
    ./system/boot.nix
    ./system/environment.nix
    ./system/network.nix
    ./system/systemd.nix
    ./system/security.nix

    ## Users
    ./system/user.nix

    ## Services
    ./service/ssh.nix
  ];

  system.stateVersion = "17.09";
}
