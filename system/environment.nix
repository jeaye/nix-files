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

  # Build all packages in a chroot
  nix.useSandbox = true;
  nix.allowedUsers = [];
  nix.extraOptions =
  ''
    auto-optimise-store = true
    build-use-sandbox = relaxed
  '';

  # This is a headless machine; no need for anything fancy
  environment.noXlibs = true;
  fonts.fontconfig.enable = false;
  sound.enable = false;

  # Auto GC every morning
  nix.gc.automatic = false;
  services.cron.systemCronJobs = [ "0 3 * * * root /etc/admin/optimize-nix" ];
}
