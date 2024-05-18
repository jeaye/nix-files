{ config, pkgs, ... }:

{
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # Disable beep.
  boot.blacklistedKernelModules = [ "snd_pcsp" "pcspkr" ];
}
