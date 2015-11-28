{ config, pkgs, ... }:

{
  security.sudo = {
    enable = false;
    wheelNeedsPassword = true;
  };

  security.pam.loginLimits = [
    { domain = "*"; item = "nproc"; type = "soft"; value = "500"; }
    { domain = "*"; item = "nproc"; type = "hard"; value = "500"; }
  ];

  users.extraUsers.jeaye = {
    isNormalUser = true;
    home = "/home/jeaye";
    extraGroups = [ "wheel" ];
  };
}
