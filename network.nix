{ config, pkgs, ... }:

{
  networking.hostName = "nixos";

  # TODO
  networking.wireless.enable = false;

  # SSH
  services.openssh.enable = true;
}
