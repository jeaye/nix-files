{ config, pkgs, ... }:

{
  users.users.git =
  {
    isNormalUser = true;
    home = "/etc/user/git";
    createHome = true;
  };

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
        chown -R git:users /etc/user/git
      '';
    };
  };
}
