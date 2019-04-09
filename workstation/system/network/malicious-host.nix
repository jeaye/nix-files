# Originally from https://github.com/michalrus/dotfiles/blob/master/nixos-config/machines/desktop/modules/malicious-hosts.nix
{ config, lib, pkgs, ... }:

let
  danPollock = pkgs.fetchurl
  {
    url = "http://someonewhocares.org/hosts/zero/hosts";
    sha256 = "1zyzj0nd1gvsm16svlhkkp25j5bcaf33x1kz8mmjryl00323flsv";
  };
in
{
  networking.extraHosts = builtins.readFile danPollock;
}
