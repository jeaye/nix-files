{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./grub.nix
    ./user.nix
    ./x11.nix
    ./browse.nix
    ./dev.nix
    ./media.nix
    ./network.nix
  ];

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Singapore";
  services.ntp.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    wget
    vimHugeX
    vimPlugins.YouCompleteMe
    tmux
    unzip
  ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "15.09";
}
