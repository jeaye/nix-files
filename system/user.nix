{ config, pkgs, ... }:

{
  security.sudo =
  {
    enable = false;
    wheelNeedsPassword = true;
  };

  security.pam.loginLimits =
  [
    { domain = "*"; item = "nproc"; type = "soft"; value = "500"; }
    { domain = "*"; item = "nproc"; type = "hard"; value = "500"; }
    { domain = "*"; item = "maxlogins"; type = "hard"; value = "3"; }
  ];

  users.users.jeaye =
  {
    isNormalUser = true;
    home = "/home/jeaye";
    extraGroups = [ "wheel" ];
  };

  # Allow useradd/groupadd imperatively
  users.mutableUsers = true;

  # Help prevent brute-force password attacks
  services.fail2ban =
  {
    enable = false;
    jails.ssh-iptables = "enabled = true";
  };
}
