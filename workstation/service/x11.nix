{ config, pkgs, ... }:

{
  services.xserver =
  {
    enable = true;
    autorun = false;
    layout = "us";
    tty = 2;

    windowManager =
    {
      default = "i3";
      i3 =
      {
        enable = true;
        extraPackages = with pkgs; [ dmenu i3status i3lock hsetroot xautolock ];
      };
    };
    desktopManager =
    {
      default = "none";
      xterm.enable = false;
    };
    # Apparently this still needs to be enabled, even with xinit.
    displayManager.slim.enable = true;

    libinput =
    {
      enable = true;
      tapping = false;
      clickMethod = "clickfinger";
      disableWhileTyping = true;
      scrollMethod = "twofinger";
      naturalScrolling = true;
    };
  };

  fonts =
  {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs;
    [
      inconsolata # Monospaced
      terminus_font # The best
      unifont # Some international fonts
    ];
  };

  services.redshift =
  {
    enable = true;
    temperature.day = 5000;
    temperature.night = 4500;
    latitude = "37.5778696";
    longitude = "-122.34809";
  };

  environment.sessionVariables =
  {
    # Allow GTK 2.0/3.0 themes to be found.
    GTK_DATA_PREFIX = "/run/current-system/sw";
    # Allow KDE apps to work better in i3.
    DESKTOP_SESSION = "kde";
  };
}
