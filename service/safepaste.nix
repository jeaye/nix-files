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
      # TODO: Link these in
      #imports =
      #[
      #  ./system/environment.nix
      #  ./system/network.nix
      #  ./system/systemd.nix
      #];

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

      environment.etc."user/safepaste/run-server" =
      {
        text =
        ''
          #!/run/current-system/sw/bin/bash
          set -eu
          export PATH=${pkgs.openssl}/bin:$PATH

          for p in about donate;
          do
            ${pkgs.safepaste}/bin/encrypt $p ${pkgs.safepaste}/share /etc/user/safepaste/paste
          done
          ${pkgs.openjdk}/bin/java -jar ${pkgs.safepaste}/bin/safepaste.jar
        '';
        mode = "0775";
      };

      systemd.services.safepaste =
      {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig =
        {
          User = "safepaste";
          WorkingDirectory = "/etc/user/safepaste";
          ExecStart = "/etc/user/safepaste/run-server";
        };
      };

      services.cron.systemCronJobs =
      [
        "0 */1 * * * safepaste ${pkgs.safepaste}/bin/clean-expired /etc/user/safepaste/paste"
      ];

      users.users.safepaste =
      {
        isNormalUser = false;
        home = "/etc/user/safepaste";
        createHome = true;
      };
      environment.etc."user/safepaste/paste/.manage-directory".text = "";

      system.activationScripts =
      {
        safepaste-home =
        {
          deps = [];
          text =
          ''
            chown -R safepaste:users /etc/user/safepaste
          '';
        };
      };

      networking.firewall =
      {
        allowedTCPPorts =
        [
          3000
        ];
      };

      services.fail2ban =
      {
        enable = true;
        jails.safepaste =
        ''
          filter   = safepaste
          maxretry = 10
          action   = iptables[name=safepaste, port=3001, protocol=tcp]
          bantime  = 43200
          enabled  = true
        '';
      };

      environment.etc."fail2ban/filter.d/safepaste.conf".text =
      ''
        [Definition]
        failregex = Paste from <HOST> .*
      '';
    };
  };
}
