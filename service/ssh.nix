{ config, pkgs, ... }:

{
  services.openssh =
  {
    enable = true;
    forwardX11 = false;
    permitRootLogin = "no";
    extraConfig =
    ''
      PermitEmptyPasswords no
      MaxAuthTries 5
      UseDNS no
    '';
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
}
