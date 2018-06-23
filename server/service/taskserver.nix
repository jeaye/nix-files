{ config, pkgs, ... }:

{
  services.taskserver =
  {
    enable = true;
    fqdn = "pastespace.org";
    listenHost = "::";
    organisations.default.users = [ "jeaye" ];
  };

  networking.firewall =
  {
    allowedTCPPorts = [ 53589 ];
  };
}
