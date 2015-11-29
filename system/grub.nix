{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_4_3;

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  swapDevices = [
    {
      # Nix will create this automagically
      device = "/root/swap";
      size = 1024;
    }
  ];
}
