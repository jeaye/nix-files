{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_4_3;

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };
}
