{ config, pkgs };

{
  environment.systemPackages = with pkgs; [
    vimHugeX
    vimPlugins.YouCompleteMe
    /nix/store/rkda5lij6wpw687aa3w8hc9bz6kqlhpb-color_coded
  ];
}
