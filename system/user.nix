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

  services.fail2ban =
  {
    enable = true;

    # Brute-force password attacks
    jails.ssh-iptables =
    ''
      maxretry = 5
      bantime  = 3600
      enabled  = true
    '';
    # Port scanning
    jails.port-scan =
    ''
      filter   = portscan
      action   = iptables-allports[name=portscan]
      maxretry = 3
      bantime  = 3600
      enabled  = true
    '';
  };
  environment.etc."fail2ban/filter.d/portscan.conf".text =
  ''
    [Definition]
    failregex = rejected connection: .* SRC=<HOST>
  '';

  # Limit stack size to reduce memory usage
  environment.etc."default/fail2ban" =
  {
    text = "ulimit -s 256";
    mode = "0755";
  };
}
