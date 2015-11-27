{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tmux
    weechat
    mutt
  ];

  users.extraUsers.irc = {
    isNormalUser = true;
    home = "/home/irc";
  };
}
