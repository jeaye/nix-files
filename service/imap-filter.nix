{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    imapfilter
  ];
}
