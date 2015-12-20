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
      gnupg = pkgs.gnupg.override { x11Support = false; };
    };
  };

  services.locate.enable = true;

  # Build all packages in a chroot
  nix.useChroot = true;

  # This is a headless machine; no need for anything fancy
  environment.noXlibs = true;
  fonts.fontconfig.enable = false;
  sound.enable = false;

  # Auto GC every morning
  nix.gc.automatic = true;
  nix.gc.dates = "03:00";
}
