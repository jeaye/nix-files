{ config, pkgs, ... }:

{
  # Disable beep
  boot.blacklistedKernelModules = [ "snd_pcsp" "pcspkr" ];
}
