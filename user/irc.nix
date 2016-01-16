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
    extraGroups = [ "git" ];
  };

  # TODO: Setup configs
  system.activationScripts =
  {
    usenet-home =
    {
      deps = [];
      text =
      ''
        ln -sf /etc/user/dotfiles/weechat /etc/user/irc/.weechat
      '';
    };
  };
}
