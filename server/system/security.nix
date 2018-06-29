{ config, pkgs, ... }:

{
  security.sudo =
  {
    enable = false;
    wheelNeedsPassword = true;
  };
}
