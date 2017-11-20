{ config, pkgs, ... }:

{
  services.xserver =
  {
    enable = true;
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
    displayManager.slim.enable = true;

    autorun = true;

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
}
