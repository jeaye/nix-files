{ config, pkgs, ... }:

{
  i18n =
  {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "America/Los_Angeles";
  services.ntp.enable = false;

  programs.bash.enableCompletion = true;

  services.locate.enable = true;

  nix.allowedUsers = [ "@wheel" ];
  nix.extraOptions =
  ''
    build-use-sandbox = false
    build-use-chroot = false
  '';
}
