{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./grub.nix
    ./user.nix
    ./vim.nix
    ./network.nix
    ./httpd.nix
    ./postfix.nix
    ./dovecot.nix
    ./fiche.nix
    ./irc.nix
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
    unzip
    git
    htop
    bashCompletion
  ];

  programs.bash.enableCompletion = true;

  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      fiche = pkgs.callPackage ./pkg/fiche.nix { };
       gnupg = pkgs.gnupg.override { x11Support = false; };
    };
  };

  # Don't bring in any X dependencies
  environment.noXlibs = true;
  fonts.enableFontConfig = false;

  services.locate.enable = true;
  services.cron = {
    enable = true;
    systemCronJobs = [
      # Clean up unused packages daily
      "0 0 * * * root nix-collect-garbage"
    ];
  };

  sound.enable = false;

  nix.maxJobs = 8;

  system.stateVersion = "15.09";
}

# TODO:
# OpenSSL keys declaratively
# Bring in weechat/mutt configs
