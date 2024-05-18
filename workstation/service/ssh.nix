{ config, pkgs, ... }:

{
  services.openssh.allowSFTP = true;
  networking.firewall.allowedTCPPorts = [ 2234 ];
}
