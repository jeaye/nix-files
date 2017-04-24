{ config, pkgs, lib, ... }:

{
  system.activationScripts =
  {
    rainloop =
    {
      deps = [];
      path = [pkgs.curl pkgs.wget pkgs.gnupg pkgs.rsync pkgs.unzip];
      text = lib.readFile ./data/upgrade-rainloop;
    };
  };
}
