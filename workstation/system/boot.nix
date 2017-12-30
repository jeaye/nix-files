{ config, pkgs, ... }:

{
  boot =
  {
    loader.grub.device = "/dev/sda";

    kernelModules =
    [
      # Audio
      "snd_mixer_oss" "snd_pcm_oss"

      # Network
      "af_packet"
      "fjes" # Fujitsu extended socket
      "b43" # Broadcom ethernet
      "fuse"

      # Graphics
      "kfd" # AMD GPU

      # Crypto
      "ctr" "ccm"
      "tpm" "tpm_tis" "tpm_tis_core"
    ];
  };
}
