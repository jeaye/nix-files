{ config, pkgs, ... }:

{
  boot.loader.grub.device = "/dev/sda";

  services.nixosManual.ttyNumber = 6;
}
