{ config, pkgs, ... }:

{
  # TODO: Rate limit

  containers.safepaste =
  {
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";

    config = { config, pkgs, ... }:
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

      systemd.services.safepaste =
      {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig =
        {
          User = "safepaste";
          WorkingDirectory = "~";
          ExecStart =
          ''
            for p in about donate;
            do
              #${pkgs.safepaste}/bin/encrypt $p ${pkgs.safepaste}/share ~/paste
              echo "encrypting $p"
            done
            ${pkgs.openjdk}/bin/java -jar ${pkgs.safepaste}/bin/safepaste.jar
          '';
        };
      };

      services.cron.systemCronJobs =
      [
        "0 */1 * * * safepaste ${pkgs.safepaste}/bin/clean-expired ~/paste"
      ];

      users.users.safepaste =
      {
        isNormalUser = false;
        home = "/etc/user/safepaste";
        createHome = true;
      };
      environment.etc."user/safepaste/paste/.manage-directory".text = "";

      networking.firewall =
      {
        allowedTCPPorts =
        [
          3000
        ];
      };
    };
  };
}
