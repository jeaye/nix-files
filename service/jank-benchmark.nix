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
      jank-benchmark = pkgs.callPackage ../pkg/jank-benchmark.nix { };
    };
  };

  environment.etc."user/jank-benchmark/run-server" =
  {
    text =
    ''
      #!/run/current-system/sw/bin/bash
      set -eu
      export PATH=${pkgs.git}/bin:${pkgs.leiningen}/bin:$PATH

      ${pkgs.openjdk}/bin/java -jar ${pkgs.jank-benchmark}/bin/jank-benchmark.jar
    '';
    mode = "0775";
  };

  systemd.services.jank-benchmark =
  {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig =
    {
      User = "jank-benchmark";
      WorkingDirectory = "/etc/user/jank-benchmark";
      ExecStart = "/etc/user/jank-benchmark/run-server";
    };
  };

  users.users.jank-benchmark =
  {
    isNormalUser = false;
    home = "/etc/user/jank-benchmark";
    createHome = true;
  };

  system.activationScripts =
  {
    jank-benchmark-home =
    {
      deps = [];
      text =
      ''
        chown -R jank-benchmark:users /etc/user/jank-benchmark
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 3001 ];
}
