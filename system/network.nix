{ config, pkgs, ... }:

{
  networking =
  {
    hostName = "nixums";

    wireless.enable = false;
    enableIPv6 = false;

    firewall =
    {
      enable = true;
      allowPing = true;
    };
  };
}
