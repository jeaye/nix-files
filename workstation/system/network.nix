{ config, pkgs, ... }:

{
  networking =
  {
    hostName = "oryx";

    #wireless.enable = true;
    enableIPv6 = true;
  };
}
