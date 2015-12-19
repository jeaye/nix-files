{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    taskserver
  ];
}
