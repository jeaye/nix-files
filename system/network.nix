{ config, pkgs, ... }:

{
  networking =
  {
    hostName = "nixums";

    wireless.enable = false;
    enableIPv6 = false;

    # Allow containers to have private networks
    nat =
    {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "eth0";
    };

    firewall =
    {
      enable = true;
      allowPing = true;
    };
  };
}
