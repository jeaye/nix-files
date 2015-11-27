{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./grub.nix
    ./user.nix
    ./vim.nix
    ./network.nix
  ];

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "America/Los_Angeles";
  services.ntp.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    elinks
    tmux
    unzip
  ];

  services.locate.enable = true;

  system.stateVersion = "15.09";
}
