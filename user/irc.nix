{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    weechat
    aspell
    aspellDicts.en
  ];

  users.users.irc =
  {
    isNormalUser = true;
    home = "/etc/user/irc";
    createHome = true;
    extraGroups = [ "git" ];
  };

  system.activationScripts =
  {
    irc-home =
    {
      path = [];
      text =
      ''
        ln -sf /etc/user/dotfiles/weechat /etc/user/irc/.weechat
      '';
    };
  };

  networking.firewall =
  {
    allowedTCPPorts =
    [
      113 # ident
    ];
  };
}
