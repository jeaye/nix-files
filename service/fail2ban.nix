{ config, pkgs, ... }:

{
  services.fail2ban =
  {
    enable = true;

    jails.DEFAULT =
    ''
      bantime  = 3600
    '';
    jails.sshd =
    ''
      filter = sshd
      maxretry = 5
      action   = iptables[name=ssh, port=ssh, protocol=tcp]
      enabled  = true
    '';
    jails.sshd-ddos =
    ''
      filter = sshd-ddos
      maxretry = 2
      action   = iptables[name=ssh, port=ssh, protocol=tcp]
      enabled  = true
    '';
    jails.port-scan =
    ''
      filter   = port-scan
      action   = iptables-allports[name=port-scan]
      maxretry = 2
      bantime  = 7200
      enabled  = true
    '';
    jails.postfix =
    ''
      filter   = postfix
      maxretry = 3
      action   = iptables[name=postfix, port=smtp, protocol=tcp]
      enabled  = true
    '';
    jails.postfix-sasl =
    ''
      filter   = postfix-sasl
      maxretry = 3
      action   = iptables[name=postfix, port=smtp, protocol=tcp]
      enabled  = true
    '';
    jails.postfix-ddos =
    ''
      filter   = postfix-ddos
      maxretry = 5
      action   = iptables[name=postfix, port=smtp, protocol=tcp]
      bantime  = 7200
      enabled  = true
    '';
    #jails.dovecot =
    #''
    #  filter   = dovecot
    #  maxretry = 5
    #  action   = iptables[name=dovecot, port=imap, protocol=tcp]
    #             iptables[name=dovecot, port=imaps, protocol=tcp]
    #             iptables[name=dovecot, port=submission, protocol=tcp]
    #  enabled  = true
    #'';
  };
  environment.etc."fail2ban/filter.d/port-scan.conf".text =
  ''
    [Definition]
    failregex = rejected connection: .* SRC=<HOST>
    ignoreip = 202.156.237.206
  '';
  environment.etc."fail2ban/filter.d/postfix-ddos.conf".text =
  ''
    [Definition]
    failregex = lost connection after EHLO from .*[<HOST>]
  '';

  # Limit stack size to reduce memory usage
  systemd.services.fail2ban.serviceConfig.LimitSTACK = 256 * 1024;
}
