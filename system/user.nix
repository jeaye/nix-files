{ config, pkgs, ... }:

{
  security.sudo =
  {
    enable = false;
    wheelNeedsPassword = true;
  };

  security.pam.loginLimits =
  [
    { domain = "*"; item = "nproc"; type = "soft"; value = "256"; }
    { domain = "*"; item = "nproc"; type = "hard"; value = "256"; }
    { domain = "*"; item = "maxlogins"; type = "hard"; value = "3"; }
    { domain = "*"; item = "nofile"; type = "hard"; value = "512"; }
  ];

  users.users.jeaye =
  {
    isNormalUser = true;
    home = "/etc/user/jeaye";
    extraGroups = [ "wheel" ];
  };

  users.users.fu-er =
  {
    isNormalUser = true;
    home = "/etc/user/fu-er";
  };

  # Allow useradd/groupadd imperatively
  users.mutableUsers = true;
}
