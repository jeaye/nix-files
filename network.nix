{ config, pkgs, ... }:

{
  networking.hostName = "nixos";

  networking.wireless.enable = false;

  services.openssh.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 ];
    allowPing = true;
  };
}
