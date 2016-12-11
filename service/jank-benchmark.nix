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
      nix-benchmark = pkgs.callPackage ../pkg/nix-benchmark.nix { };
    };
  };
}
