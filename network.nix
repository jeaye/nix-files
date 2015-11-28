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
      80 # http
      143 # imap (dovecot)
      9999 # fiche
    ];
    allowPing = true;
  };
}
