{ config, pkgs, ... }:

{
  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      fiche = pkgs.callPackage ../pkg/fiche.nix { };
    };
  };

  containers.fiche =
  {
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";

    config = { config, pkgs, ... }:
    {
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
                                    -o /home/http/pastespace.org \
                                    -l /home/http/fiche.log
          '';
        };
      };

      # Clean up old pastes
      services.cron.systemCronJobs =
      [
        "0 0 * * * http ${pkgs.findutils}/bin/find /home/http/pastespace.org/* -mtime +14 -type d -exec rm -r {} \\;"
      ];

      networking.firewall.allowedTCPPorts = [ 9999 ];
    };
  };
}
