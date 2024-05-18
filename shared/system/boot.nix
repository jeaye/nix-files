{ config, pkgs, ... }:

{
  boot.kernelParams = [ "boot.shell_on_fail" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
