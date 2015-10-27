{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rxvt_unicode
    i3status
    dmenu
    hsetroot
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    tty = 2;
    synaptics.enable = true;
    synaptics.twoFingerScroll = true;
    desktopManager.xterm.enable = false; # Disable "xterm + i3" session
    windowManager.i3.enable = true;
    windowManager.default = "i3";
  };

  # Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  # Enable acceleration for 32bit apps as well
  hardware.opengl.driSupport32Bit = true;

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
