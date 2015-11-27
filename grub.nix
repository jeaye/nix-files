{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_4_2;

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };
}
