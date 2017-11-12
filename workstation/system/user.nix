{ config, pkgs, ... }:

{
  security.sudo =
  {
    enable = true;
    wheelNeedsPassword = true;
  };
}
