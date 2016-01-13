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
    home = "/etc/user/irc";
    createHome = true;
  };

  # TODO: Setup configs
}
