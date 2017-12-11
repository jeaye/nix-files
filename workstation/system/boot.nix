{ config, pkgs, ... }:

{
  boot =
  {
    loader.grub.device = "/dev/sda";
    tmpOnTmpfs = true;
  };

  services.nixosManual.ttyNumber = 6;
}
