{ config, pkgs, ... }:

{
  services.fail2ban =
  {
    enable = true;

    jails.ssh-iptables =
    ''
      maxretry = 5
      bantime  = 3600
      enabled  = true
    '';
    jails.port-scan =
    ''
      filter   = portscan
      action   = iptables-allports[name=portscan]
      maxretry = 2
      bantime  = 7200
      enabled  = true
    '';
    jails.postfix =
    ''
      filter   = postfix
      port     = smtp,ssmtp
      maxretry = 3
      bantime  = 7200
      enabled  = true
    '';
    jails.postfix-sasl =
    ''
      filter   = postfix
      port     = smtp,ssmtp
      maxretry = 3
      bantime  = 7200
      enabled  = true
    '';
  };
  environment.etc."fail2ban/filter.d/portscan.conf".text =
  ''
    [Definition]
    failregex = rejected connection: .* SRC=<HOST>
    ignoreip = 202.156.237.206
  '';

  # Limit stack size to reduce memory usage
  systemd.services.fail2ban.serviceConfig.LimitSTACK = 256 * 1024;
}
