{ config, pkgs, lib, ... }:

{
  users.users.jeaye =
  {
    packages = with pkgs;
    [
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
