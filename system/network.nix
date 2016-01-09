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

    # Allow containers to talk to the outside network.
    nat.enable = true;
    nat.internalInterfaces = ["ve-+"];
    nat.externalInterface = "eth0";
  };
}
