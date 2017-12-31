{ config, pkgs, lib, ... }:

{
  users.users.jeaye =
  {
    packages = with pkgs;
    [
      # Xorg
      xorg.xinit

      ## Security
      pinentry
      gnupg
      keepassx-community

      ## Editing
      neovim

      ## Browsing
      firefox

      ## Calendar
      thunderbird

      ## Music
      cmus

      ## Dictionary
      dict
      dictdDBs.wordnet
    ];
  };
}
