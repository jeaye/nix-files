{ config, pkgs, ... }:

{
  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      fiche = pkgs.callPackage ../pkg/fiche.nix { };
    };
  };

  systemd.services.fiche =
  {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig =
    {
      User = "http";
      ExecStart =
      ''
        ${pkgs.fiche}/bin/fiche -d pastespace.org \
                                -S
                                -o /etc/user/http/pastespace.org \
                                -l /etc/user/http/fiche.log
      '';
    };
  };

  # Clean up old pastes
  services.cron.systemCronJobs =
  [
    "0 0 * * * http ${pkgs.findutils}/bin/find /etc/user/http/pastespace.org/* -mtime +14 -type d -exec rm -r {} \\;"
  ];

  networking.firewall.allowedTCPPorts = [ 9999 ];
}
