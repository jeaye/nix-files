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
      ${pkgs.openjdk}/bin/java -jar ${pkgs.jank-benchmark}/bin/jank-benchmark.jar
    '';
    mode = "0775";
  };

  users.users.jank-benchmark =
  {
    isNormalUser = false;
    home = "/etc/user/jank-benchmark";
    createHome = true;
  };
  environment.etc."user/jank-benchmark/paste/.manage-directory".text = "";

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
}
