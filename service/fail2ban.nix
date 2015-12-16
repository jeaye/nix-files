{ config, pkgs, ... }:

{
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
      maxretry = 2
      bantime  = 7200
      enabled  = true
    '';
  };
  environment.etc."fail2ban/filter.d/portscan.conf".text =
  ''
    [Definition]
    failregex = rejected connection: .* SRC=<HOST>
  '';

  # Limit stack size to reduce memory usage
  systemd.services.fail2ban.serviceConfig.LimitSTACK = 256 * 1024;
}
