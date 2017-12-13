{ config, pkgs, ... }:

{
  i18n =
  {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  programs.bash.enableCompletion = true;

  nix.allowedUsers = [ "@wheel" ];
  nix.extraOptions =
  ''
    build-use-sandbox = false
    build-use-chroot = false
  '';
}
