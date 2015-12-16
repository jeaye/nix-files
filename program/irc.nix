{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    tmux
    weechat
    mutt
  ];

  users.users.irc =
  {
    isNormalUser = true;
    home = "/home/irc";
    createHome = true;
  };
}
