{ config, pkgs, ... }:

{
  networking.hostName = "nixos";

  # TODO
  networking.wireless.enable = false;

  services.openssh.enable = true;
}
