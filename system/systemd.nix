{ config, pkgs, ... }:

{
  services.journald.extraConfig =
  ''
    Storage=auto
    Compress=yes
    SystemMaxUse=1G
    RuntimeMaxUse=64M
  '';
}
