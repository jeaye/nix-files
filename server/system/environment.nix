{ config, pkgs, ... }:

{
  # This is a headless machine; no need for anything fancy... or so I thought.
  # Enabling noXlibs requires manual compilation of some large packages, like
  # openjdk. I'll try to disable it, to avoid massive compilations, with the
  # tradeoff of a larger /nix/store and attack vector.
  environment.noXlibs = false;
  fonts.fontconfig.enable = false;
  sound.enable = false;

  # Auto GC every morning
  nix.gc.automatic = false;
  services.cron.systemCronJobs = [ "0 3 * * * root /etc/admin/optimize-nix" ];

  environment.etc =
  {
    "admin/optimize-nix" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        # Delete everything from this profile that isn't currently needed
        nix-env --delete-generations old

        # Delete generations older than a week
        nix-collect-garbage
        nix-collect-garbage --delete-older-than 7d

        # Optimize
        nix-store --gc --print-dead
        nix-store --optimise
      '';
      mode = "0774";
    };
  };
}
