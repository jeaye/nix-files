{ config, pkgs, ... }:

{
  i18n =
  {
    defaultLocale = "en_US.UTF-8";
  };
  console =
  {
    keyMap = "us";
    font = "Lat2-Terminus16";
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs.bash.enableCompletion = true;

  nix.settings.allowed-users = [ "@wheel" ];
  nix.optimise =
  {
    automatic = true;
    dates = [ "weekly" ];
  };
  nix.gc =
  {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
