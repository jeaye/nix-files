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
      ExecStart = ''
        ${pkgs.tmux}/bin/tmux new-session -d -s irc ${pkgs.weechat}/bin/weechat && ${pkgs.tmux}/bin/tmux new-window ${pkgs.mutt}/bin/mutt
      '';
      ExecStop = ''
        ${pkgs.tmux}/bin/tmux kill-session -t irc
      '';
    };
  };

  users.extraUsers.irc = {
    isNormalUser = true;
    home = "/home/irc";
  };
}
