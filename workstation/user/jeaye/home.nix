{ config, pkgs, lib, ... }:

{
  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      jeaye-dotfiles = pkgs.callPackage ./pkg/dotfiles.nix { };
    };
  };

  environment.systemPackages =
  [
    pkgs.jeaye-dotfiles
  ];
}
