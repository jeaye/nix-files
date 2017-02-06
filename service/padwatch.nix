{ config, pkgs, ... }:

{
  environment.systemPackages =
  [
    pkgs.leiningen
    pkgs.openjdk
  ];

  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      padwatch = pkgs.callPackage ../pkg/padwatch.nix { };
    };
  };

  environment.etc."user/padwatch/run-server" =
  {
    text =
    ''
      #!/run/current-system/sw/bin/bash
      set -eu

      ${pkgs.openjdk}/bin/java -jar ${pkgs.padwatch}/bin/padwatch.jar
    '';
    mode = "0775";
  };

  systemd.services.padwatch =
  {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig =
    {
      User = "padwatch";
      WorkingDirectory = "/etc/user/padwatch";
      ExecStart = "/etc/user/padwatch/run-server";
    };
  };

  users.users.padwatch =
  {
    isNormalUser = false;
    home = "/etc/user/padwatch";
    createHome = true;
  };

  system.activationScripts =
  {
    padwatch-home =
    {
      deps = [];
      text =
      ''
        chown -R padwatch:users /etc/user/padwatch
      '';
    };
  };
}
