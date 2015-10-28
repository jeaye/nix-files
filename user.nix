{ config, pkgs, ... }:

{
  users.extraUsers.jeaye = {
    isNormalUser = true;
    home = "/home/jeaye";
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
  };
}
