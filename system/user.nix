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
    enable = true;
    jails.ssh =
    ''
      filter   = sshd
      action   = iptables[name=SSH, port=ssh, protocol=tcp]
      ignoreip = 127.0.0.1/8
      bantime  = 600
      findtime = 600
      maxretry = 3
      backend  = systemd
      enabled  = true
    '';
  };
}
