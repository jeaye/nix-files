{ config, pkgs, ... }:

{
  # Try to conserve RAM
  services.journald.extraConfig =
  ''
    Storage=persistent
    Compress=yes
    SystemMaxUse=1G
    RuntimeMaxUse=64M
  '';
}
