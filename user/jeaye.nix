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
        PATH=${pkgs.git}/bin:$PATH
        PATH=${pkgs.gnused}/bin:$PATH

        if [ ! -d /etc/user/jeaye/.vim ];
        then
          git clone --recursive https://github.com/jeaye/vimrc.git /etc/user/jeaye/.vim
          ln -sf /etc/user/jeaye/.vim/vimrc /etc/user/jeaye/.vimrc
        fi
      '';
    };
  };
}
