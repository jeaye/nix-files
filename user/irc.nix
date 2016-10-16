{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    tmux
    weechat
    mutt-with-sidebar
    pinentry
    gnupg
    aspell
    aspellDicts.en
  ];

  # TODO: I don't know the difference between these
  #nixpkgs.config =
  #{
  #  gnupg.x11Support = false;
  #};

  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      gnupg = pkgs.gnupg.override { x11Support = false; };
    };
  };

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
      deps = [];
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
