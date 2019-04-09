{ config, pkgs, lib, ... }:

{
  users.users.jeaye =
  {
    packages = with pkgs;
    [
      ## Xorg
      xorg.xinit

      ## Display
      redshift

      ## Security
      pinentry
      gnupg
      keepassx-community

      ## Editing
      neovim
      fzf

      ## Browsing
      firefox

      ## Calendar
      thunderbird

      ## Music
      #cmus
      mpd

      ## Dictionary
      dict
      dictdDBs.wordnet
    ];
  };
}
