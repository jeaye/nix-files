{ config, pkgs, ... }:

{
  environment.systemPackages = let pkgsUnstable = import
  (
    fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
  )
  { };
  in
  [
    pkgs.tmux
    pkgsUnstable.weechat
    pkgs.mutt
    pkgs.aspell
    pkgs.aspellDicts.en
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
    usenet-home =
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
      113 # irc (ident)
    ];
  };
}
