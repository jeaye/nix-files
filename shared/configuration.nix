{ config, pkgs, ... }:

{
  imports =
  [
    ## System
    ./system/environment.nix
    ./system/network.nix
    ./system/systemd.nix
    ./system/security.nix

    ## Users
    ./system/user.nix

    ## Services
    ./service/time.nix
    ./service/locate.nix
    ./service/ssh.nix
  ];
}
