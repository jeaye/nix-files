{ config, pkgs };

{
  environment.systemPackages = with pkgs; [
    vimHugeX
    vimPlugins.YouCompleteMe
    /nix/store/8fd65w5565kvp3kz1cfqv5lh2x0gj4h7-color_coded
  ];

  environment.etc.vimrc = {
    text = ''
      set rtp+=${pkgs.color_coded}
      source /home/jeaye/projects/vimrc/vimrc
    '';
  };
  environment.systemPackages = [ pkgs.vim ];
}
