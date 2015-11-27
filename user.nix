{ config, pkgs, ... }:

{
  security.sudo.wheelNeedsPassword = true;

  users.extraUsers.jeaye = {
    isNormalUser = true;
    home = "/home/jeaye";
    extraGroups = [ "wheel" ];
  };
}
