{ config, pkgs, lib, ... }:

{
  #users.users.jeaye =
  #{
  #  packages = with pkgs;
  #  [
  #    steam
  #  ];
  #};
  programs.steam =
  {
    enable = true;
    # TODO: Enable once this is live.
    #protontricks.enable = true;
  };

  # Needed for Rocket League.
  nixpkgs.config.permittedInsecurePackages =
  [
    "openssl-1.1.1w"
  ];
  nixpkgs.overlays = [
    (final: prev: {
      steam = prev.steam.override ({ extraPkgs ? pkgs': [], ... }: {
        extraPkgs = pkgs': (extraPkgs pkgs') ++ (with pkgs'; [
          openssl_1_1
          protontricks
        ]);
      });
    })
  ];

  programs.gamemode.enable = true;
}
