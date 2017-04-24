{ config, pkgs, lib, ... }:

{
  system.activationScripts =
  {
    rainloop =
    {
      deps = [];
      text =
      ''
        export PATH=${pkgs.curl}/bin:${pkgs.wget}/bin:${pkgs.gnupg}/bin:${pkgs.rsync}/bin:${pkgs.unzip}/bin:$PATH
        ${lib.readFile ./data/upgrade-rainloop}
      '';
    };
  };
}
