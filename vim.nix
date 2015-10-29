{ config, pkgs };

{
  environment.systemPackages = with pkgs; [
    vimHugeX
    vimPlugins.YouCompleteMe
  ];
}
