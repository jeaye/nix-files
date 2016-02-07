{ config, pkgs, ... }:

{
  environment.systemPackages = let pkgsUnstable = import
  (
    fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
  )
  { };
  in
  [
    pkgsUnstable.boot # Clojure build system
    pkgs.npm
  ];

  # TODO: Run in a container

  # TODO: Clean up old pastes
}
