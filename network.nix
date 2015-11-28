{ config, pkgs, ... }:

{
  networking.hostName = "nixos";

  networking.wireless.enable = false;

  services.openssh.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 # ssh
      25 # smtp
      80 # http
      143 # imap
      587 # smtp
      9999 # fiche
    ];
    allowPing = true;
  };
}
