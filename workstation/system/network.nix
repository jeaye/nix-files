{ config, pkgs, ... }:

{
  networking = rec
  {
    hostName = "oryx";

    enableIPv6 = false;

    networkmanager.enable = true;

    hosts =
    {
      "127.0.0.1" =
      [
        "${hostName}.localdomain"
        "${hostName}"
      ];
    };
  };

  imports =
  [
    ./network/malicious-host.nix
  ];
}
