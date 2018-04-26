{ config, pkgs, ... }:

{
  users.users.git =
  {
    isNormalUser = true;
    home = "/etc/user/git";
    createHome = true;
    extraGroups = [ "ssh" ];
  };
  users.groups.git = {};

  # Ensure some directories exist
  environment.etc."user/git/dotfiles/.manage-directory".text = "";

  # XXX: Manually bring in dotfiles repo
  system.activationScripts =
  {
    git-home =
    {
      deps = [];
      text =
      ''
        PATH=${pkgs.git}/bin:$PATH
        PATH=${pkgs.gnused}/bin:$PATH

        if [ ! -d /etc/user/dotfiles ];
        then
          git clone --recursive /etc/user/git/dotfiles /etc/user/dotfiles
        fi
        chgrp -R git /etc/user/dotfiles
        chmod -R g+w /etc/user/dotfiles
      '';
    };
  };
}
