{ config, pkgs, ... }:

{
  boot =
  {
    loader.grub.device = "/dev/sda";
  };
}
