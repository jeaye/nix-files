# Originally from https://github.com/michalrus/dotfiles/blob/master/nixos-config/machines/desktop/modules/malicious-hosts.nix
{ config, lib, pkgs, ... }:

let
  danPollock = pkgs.fetchurl
  {
    url = "http://someonewhocares.org/hosts/zero/hosts";
    sha256 = "165bp7ipxngndyj7csdvsfn3pqi9z2mfd8mkr4pjg304jp3v9iny";
  };
in
{
  networking.extraHosts = builtins.readFile danPollock;
}
