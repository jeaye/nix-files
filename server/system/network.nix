{ config, pkgs, ... }:

{
  networking =
  {
    wireless.enable = false;
    enableIPv6 = false;

    # Allow containers to have private networks
    nat =
    {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "ens3";
    };
  };
}
