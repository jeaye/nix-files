{ config, pkgs, ... }:

{
  services.xserver =
  {
    enable = true;
    layout = "us";

    windowManager =
    {
      default = "i3";
      i3.enable = true;
    };
    desktopManager =
    {
      default = "none";
      xterm.enable = false;
    };
    displayManager =
    {
      slim.enable = true;
    };

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
}
