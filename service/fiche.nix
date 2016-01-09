{ config, pkgs, ... }:

{
  containers.fiche =
  {
    privateNetwork = true;
    hostAddress = "192.168.101.10";
    localAddress = "192.168.101.11";

    config = { config, pkgs, ... }:
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
          User = "fiche";
          ExecStart =
          ''
            ${pkgs.fiche}/bin/fiche -d pastespace.org \
                                    -o /home/fiche/pastespace.org \
                                    -l /home/fiche/fiche.log
          '';
        };
      };

      # Clean up old pastes
      services.cron.systemCronJobs =
      [
        "0 0 * * * fiche ${pkgs.findutils}/bin/find /home/fiche/pastespace.org/* -mtime +14 -type d -exec rm -r {} \\;"
      ];

      networking.firewall.allowedTCPPorts = [ 9999 ];

      users.users.fiche =
      {
        isNormalUser = true;
        home = "/home/fiche";
        extraGroups = [ "fiche" ];
      };
      users.groups.fiche = {};

      system.activationScripts =
      {
        fiche =
        {
          deps = [];
          text =
          ''
            mkdir -p /home/fiche/pastespace.org
            chown fiche:fiche /home/fiche/pastespace.org
          '';
        };
      };
    };
  };
}
