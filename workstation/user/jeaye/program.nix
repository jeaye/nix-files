{ config, pkgs, lib, ... }:

{
  # TODO: Lock this to user-specific profile
  environment.systemPackages = with pkgs;
  [
    ## Security
    pinentry
    gnupg

    ## Browsing
    firefox

    ## Calendar
    thunderbird

    ## Music
    cmus
  ];
}
