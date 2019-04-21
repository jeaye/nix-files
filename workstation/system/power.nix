{ config, pkgs, ... }:

{
  powerManagement.powertop.enable = true;

  environment.systemPackages = with pkgs;
  [
    powertop # TODO: Is this needed?
  ];
}
