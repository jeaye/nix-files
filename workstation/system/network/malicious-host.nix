# Originally from https://github.com/michalrus/dotfiles/blob/master/nixos-config/machines/desktop/modules/malicious-hosts.nix
{ config, lib, pkgs, ... }:

let
  danPollock = pkgs.fetchurl
  {
    url = "http://someonewhocares.org/hosts/zero/hosts";
    # curl http://someonewhocares.org/hosts/zero/hosts | sha256sum
    sha256 = "dd5e4f9a4a3b08f8b8c5a45dcb363efeae0df47d8c80b232f8d91fb9c74ee99b";
  };
in
{
  # TODO: Hash isn't working here? Copy the whole thing in?
  #networking.extraHosts = builtins.readFile danPollock;
}
