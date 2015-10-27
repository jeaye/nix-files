{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.default = "i3";

  # Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  # Enable acceleration for 32bit apps as well
  hardware.opengl.driSupport32Bit = true;
}
