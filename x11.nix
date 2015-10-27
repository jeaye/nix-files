{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rxvt_unicode
    i3status
    dmenu
    hsetroot
  ];

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

  # Font
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts # MS free fonts
      inconsolata # Monospaced
      terminus_font # The best
      unifont # Some international fonts
    ];
  };
}
