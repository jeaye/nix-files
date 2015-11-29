{ config, pkgs, ... }:

{
  networking.hostName = "nixos";

  networking.wireless.enable = false;

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 # ssh
      25 # smtp (postfix)
      80 # http
      143 # imap (dovecot)
      587 # smtp (postfix)
      993 # imap (dovecot)
      9999 # fiche
    ];
    allowPing = true;
  };

  services.openssh = {
    enable = true;
    forwardX11 = false;
    permitRootLogin = "without-password"; # Force key-based authentication
    extraConfig = ''
      PermitEmptyPasswords no
    '';
  };
}
