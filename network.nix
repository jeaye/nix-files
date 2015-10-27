{ config, pkgs, ... }:

{
  networking.hostName = "nixos";

  # TODO
  networking.wireless.enable = false;

  services.openssh.enable = true;

  # Firewall
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 22 ];
    allowPing = true;
  };
}
