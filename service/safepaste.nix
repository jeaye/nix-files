{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    boot # Clojure build system
  ];

  # TODO: Run in a container

  # TODO: Clean up old pastes
}
