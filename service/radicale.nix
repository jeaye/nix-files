{ config, pkgs, ... }:

{
  services.radicale.enable = true;

  networking.firewall =
  {
    allowedTCPPorts =
    [
      5232 # caldav
    ];
  };
}
