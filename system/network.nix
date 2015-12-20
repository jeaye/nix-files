{ config, pkgs, ... }:

{
  networking.hostName = "nixums";

  networking.wireless.enable = false;

  networking.enableIPv6 = false;

  networking.firewall =
  {
    enable = true;
    allowedTCPPorts =
    [
      22 # ssh
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
