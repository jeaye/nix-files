{ config, pkgs, ... }:

{
  boot =
  {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  fileSystems."/".options = [ "noatime" ];
}
