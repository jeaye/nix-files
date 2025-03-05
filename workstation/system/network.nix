{ config, pkgs, ... }:

{
  networking = rec
  {
    hostName = "thelio";

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

  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  /* Required to get DNS working with mullvad.
   * https://discourse.nixos.org/t/connected-to-mullvadvpn-but-no-internet-connection/35803/15
   */
  networking.resolvconf.enable = false;

  networking.firewall.allowedTCPPorts = [
    80
    443
    1401
    # Minecraft server
    25565
  ];
  networking.firewall.allowedUDPPorts = [ 53 1194 1195 1196 1197 1300 1301 1302 1303 1400 ];

  imports =
  [
    ./network/malicious-host.nix
  ];
}
