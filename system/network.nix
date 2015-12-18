{ config, pkgs, ... }:

{
  networking.hostName = "nixums";

  networking.wireless.enable = false;

  networking.enableIPv6 = false;

  # Firewall
  networking.firewall =
  {
    enable = true;
    allowedTCPPorts =
    [
      22 # ssh
      25 # smtp (postfix)
      80 # http
      143 # imap (dovecot)
      443 # https
      587 # smtp (postfix)
      993 # imap (dovecot)
      9999 # fiche
    ];
    allowPing = true;
  };

  services.openssh =
  {
    enable = true;
    forwardX11 = false;
    permitRootLogin = "no";
    extraConfig = ''
      PermitEmptyPasswords no
      MaxAuthTries 5
      UseDNS no
    '';
  };
}
