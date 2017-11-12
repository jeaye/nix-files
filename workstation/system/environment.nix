{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  sound.enable = true;

  programs.gnupg.agent =
  {
    enable = true;
    enableSSHSupport = true;
  };
}
