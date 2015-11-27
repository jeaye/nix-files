{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tmux
    weechat
    mutt
  ];

  systemd.services.ircSession = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "forking";
      User = "irc";
      ExecStart = ''${pkgs.tmux}/bin/tmux new-session -s %u -d'';
      ExecStop = ''${pkgs.tmux}/bin/tmux kill-session -t %u'';
    };
  };

  users.extraUsers.irc = {
    isNormalUser = true;
    home = "/home/irc";
  };
}
