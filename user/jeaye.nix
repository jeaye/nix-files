{ config, pkgs, ... }:

{
  users.users.jeaye =
  {
    isNormalUser = true;
    home = "/etc/user/jeaye";
    extraGroups = [ "wheel" ];
  };

  system.activationScripts =
  {
    jeaye-home =
    {
      deps = [];
      text =
      ''
        ln -sf /etc/user/vimrc/vimrc /etc/user/jeaye/.vimrc
        ln -sf /etc/user/vimrc /etc/user/jeaye/.vim
      '';
    };
  };
}
