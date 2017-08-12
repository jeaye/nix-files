{ config, pkgs, ... }:

{
  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      fail2ban = pkgs.fail2ban.overrideDerivation (oldAttrs :
      {
        src = pkgs.fetchzip
        {
          name   = "fail2ban-0.9.3-src";
          url    = "https://github.com/fail2ban/fail2ban/archive/0.9.3.tar.gz";
          sha256 = "1pwgr56i6l6wh2ap8b5vknxgsscfzjqy2nmd1c3vzdii5kf72j0f";
        };
      });
    };
  };

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
      maxretry = 4
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
    # TODO: Move these to their appropriate files
    jails.postfix =
    ''
      filter   = postfix
      maxretry = 3
      action   = iptables[name=postfix, port=smtp, protocol=tcp]
      enabled  = false
    '';
    jails.postfix-sasl =
    ''
      filter   = postfix-sasl
      maxretry = 3
      action   = iptables[name=postfix, port=smtp, protocol=tcp]
      enabled  = true
    '';
    jails.postfix-custom =
    ''
      filter   = postfix-custom
      maxretry = 3
      action   = iptables[name=postfix, port=submission, protocol=tcp]
                 iptables[name=postfix, port=smtp, protocol=tcp]
      bantime  = 7200
      enabled  = true
    '';
  };
  environment.etc."fail2ban/filter.d/port-scan.conf".text =
  ''
    [Definition]
    failregex = rejected connection: .* SRC=<HOST>
  '';
  environment.etc."fail2ban/filter.d/postfix-custom.conf".text =
  ''
    [Definition]
    failregex = lost connection after (EHLO|AUTH) from \S+\[<HOST>\]
                reject: RCPT from \S+\[<HOST>\]: 450 4.7.1
                reject: RCPT from \S+\[<HOST>\]: 554 5\.7\.1
                reject: VRFY from \S+\[<HOST>\]: 550 5\.1\.1
                improper command pipelining after \S+ from [^[]*\[<HOST>\]:?
  '';

  # Limit stack size to reduce memory usage
  systemd.services.fail2ban.serviceConfig.LimitSTACK = 256 * 1024;
}
