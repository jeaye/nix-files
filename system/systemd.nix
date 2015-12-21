{ config, pkgs, ... }:

{
  # Try to conserve RAM
  services.journald.extraConfig =
  ''
    Storage=persistent
    Compress=yes
  '';
}
