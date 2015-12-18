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
      maxretry = 2
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
  environment.etc."fail2ban/filter.d/postfix.conf".text =
  ''
    [Definition]
    failregex = reject: RCPT from (.*)\[<HOST>\]: 550 5.1.1
                reject: RCPT from (.*)\[<HOST>\]: 450 4.7.1
                reject: RCPT from (.*)\[<HOST>\]: 554 5.7.1
  '';

  # Limit stack size to reduce memory usage
  systemd.services.fail2ban.serviceConfig.LimitSTACK = 256 * 1024;
}
