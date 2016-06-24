{ config, pkgs, ... }:

{
  environment.systemPackages = let pkgsUnstable = import
  (
    fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
  )
  { };
  in
  environment.systemPackages =
  [
    pkgs.tmux
    pkgsUnstable.weechat
    pkgs.mutt-with-sidebar
    pkgs.gnupg
    pkgs.aspell
    pkgs.aspellDicts.en
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
