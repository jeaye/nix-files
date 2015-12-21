{ config, pkgs, ... }:

{
  services.journald.extraConfig =
  ''
    Storage=persist
    Compress=yes
    SystemMaxUse=128M
    RuntimeMaxUse=8M
  '';
}
