{ config, pkgs, ... }:

{
  networking =
  {
    firewall =
    {
      enable = true;
      allowPing = true;
    };
  };
}
