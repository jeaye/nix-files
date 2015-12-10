{ config, pkgs, ... }:

{
  i18n =
  {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "America/Los_Angeles";
  services.ntp.enable = true;

  environment.systemPackages = with pkgs;
  [
    wget
    elinks
    unzip
    git
    htop
    bashCompletion
  ];

  programs.bash.enableCompletion = true;

  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      fiche = pkgs.callPackage ../pkg/fiche.nix { };
      gnupg = pkgs.gnupg.override { x11Support = false; };
    };
  };

  # Build all packages in a chroot
  nix.useChroot = true;

  # Don't bring in any X dependencies
  environment.noXlibs = true;
  fonts.fontconfig.enable = false;
}
