{ config, pkgs, ... }:

{
  sound.enable = true;

  # Disable beep
  boot.blacklistedKernelModules = [ "snd_pcsp" "pcspkr" ];
}
