{ config, pkgs, ... }:

{
  users.extraUsers.jeaye = {
    isNormalUser = true;
    home = "/home/jeaye";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = "/run/current-system/sw/bin/zsh";
    uid = 1000;
  };
}
