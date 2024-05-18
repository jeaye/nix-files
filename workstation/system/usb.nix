{ config, pkgs, ... }:

{
  # Enable USB auto-mounting.
  services.gvfs.enable = true;
}
