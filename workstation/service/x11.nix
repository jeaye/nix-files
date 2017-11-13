{ config, pkgs, ... }:

{
  services.xserver =
  {
    enable = true;
    layout = "us";

    displayManager =
    {
      slim.enable = true;
      slim.defaultUser = "jeaye";
      sessionCommands =
      ''
      '';
    };

    desktopManager.xterm.enable = false;
    windowManager.default = "i3";
    windowManager.i3.enable = true;

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
