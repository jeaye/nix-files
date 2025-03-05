{ config, pkgs, ... }:

{
  virtualisation.docker =
  {
    enable = true;
    enableNvidia = false;
  };
}
