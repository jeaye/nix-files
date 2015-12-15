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
    { domain = "*"; item = "nofile"; type = "hard"; value = "512"; }
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
    jails.DEFAULT =
    ''
      maxretry = 5
      bantime  = 3600
    '';

    jails.ssh-iptables = "enabled = true";
    jails.port-scan =
    ''
      filter   = portscan
      action   = iptables-allports[name=portscan]
      enabled  = true
    '';
  };
  environment.etc."fail2ban/filter.d/portscan.conf".text =
  ''
    [Definition]
    failregex = rejected connection: .* SRC=<HOST>
  '';
}
