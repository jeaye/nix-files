{ config, pkgs, ... }:

{
  users.extraUsers.jeaye = {
    isNormalUser = true;
    home = "/home/jeaye";
    extraGroups = [ "wheel" ];
    uid = 1000;
  };
}
