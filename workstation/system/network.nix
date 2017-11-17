{ config, pkgs, ... }:

{
  networking =
  {
    hostName = "oryx";

    enableIPv6 = true;

    networkmanager.enable = true;
  };
}
