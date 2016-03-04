{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_4_3;
  boot.kernelParams = [ "boot.shell_on_fail" ];

  boot.loader.grub =
  {
    enable = true;
    version = 2;
  };

  # Clean up /tmp on boot
  boot.cleanTmpDir = true;

  swapDevices =
  [
    {
      # Nix will create this automagically
      device = "/swap";
      size = 2048;
    }
  ];
}
