{ config, pkgs, ... }:

{
  security.sudo = {
    enable = false;
    wheelNeedsPassword = true;
  };

  security.pam.loginLimits = [
    { domain = "*"; item = "nproc"; type = "soft"; value = "500"; }
    { domain = "*"; item = "nproc"; type = "hard"; value = "500"; }
    { domain = "*"; item = "maxlogins"; type = "hard"; value = "3"; }
  ];

  users.users.jeaye = {
    isNormalUser = true;
    home = "/home/jeaye";
    createHome = true;
    hashedPassword = "a860c9cae665b4d3240d1518cd55406cdf3a15a0d356aa965af1cf74fab62ed33f41ce112935bd34bb8ba047f1d3b5337f0c7e775dc8ad942b7995ffcf58b0d3";
    extraGroups = [ "wheel" ];
  };

  # Can't use useradd/groupadd imperatively
  users.mutableUsers = false;
}
