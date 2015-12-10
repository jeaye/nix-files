{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_4_3;
  boot.kernelParams = ["boot.shell_on_fail"];

  boot.loader.grub =
  {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  # Clean up /tmp on boot
  boot.cleanTmpDir = true;

  swapDevices =
  [
    {
      # Nix will create this automagically
      device = "/root/swap";
      size = 1024;
    }
  ];
}
