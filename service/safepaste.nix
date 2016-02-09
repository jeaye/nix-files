{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    openjdk
  ];

  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      safepaste = pkgs.callPackage ../pkg/safepaste.nix { };
    };
  };

  # TODO: Run in a container
  systemd.services.safepaste =
  {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig =
    {
      User = "safepaste";
      ExecStart =
      ''
        ${pkgs.openjdk}/bin/java -jar ${pkgs.safepaste}/bin/safepaste.jar
      '';
    };
  };

  # TODO: Clean up old pastes
  services.cron.systemCronJobs =
  [
    "0 0 * * * safepaste ${pkgs.safepaste}/bin/clean-expired /etc/user/safepaste/paste"
  ];

  # TODO: Limit posts
}
