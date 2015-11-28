{ config, pkgs, ... }:

# TODO: SASL and TLS
{
  services.postfix = rec {
    enable = true;
    hostname = "mail.pastespace.org";
    domain = "pastespace.org";
    origin = "${domain}";
    destination = "${hostname}, ${domain}, localhost.${domain}, localhost";
    networksStyle = "host";
    virtual = ''
      contact@pastespace.org     jeaye
    '';
    extraAliases = ''
      # Person who should get root's mail. Don't receive mail as root!
      root:   jeaye

      # Basic system aliases -- these MUST be present
      MAILER-DAEMON:  postmaster
      postmaster: root

      # General redirections for pseudo accounts
      bin:      root
      daemon:   root
      named:    root
      nobody:   root
      uucp:     root
      www:      root
      ftp-bugs: root
      postfix:  root

      # Well-known aliases
      manager:  root
      dumper:   root
      operator: root
      abuse:    postmaster

      # Trap decode to catch security attacks
      decode:   root
    '';
    extraConfig = ''
      home_mailbox = Maildir/
      virtual_alias_domains = jeaye.com fu-er.com furthington.com arrownext.com
    '';
  };
}
