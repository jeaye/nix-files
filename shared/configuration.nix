{ config, pkgs, ... }:

{
  imports =
  [
    ## More secure defaults
    <nixpkgs/nixos/modules/profiles/hardened.nix>

    ## System
    ./system/boot.nix
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
