{ config, pkgs, ... }:

# TODO: SASL and TLS
{
  services.postfix = rec {
    enable = true;
    domain = "pastespace.org";
    hostname = "mail.${domain}";
    origin = "${domain}";
    destination = [
      "${hostname}"
      "${domain}"
      "localhost.${domain}"
      "localhost"
    ];
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

      # Security
      smtpd_use_tls=yes
      smtpd_tls_cert_file=/etc/ssl/certs/mail.pem
      smtpd_tls_key_file=/etc/ssl/private/mail.key
      smtpd_tls_session_cache_database = btree:''${data_directory}/smtpd_scache
      smtp_tls_session_cache_database = btree:''${data_directory}/smtp_scache
      smtpd_tls_security_level=may
      smtpd_tls_protocols = !SSLv2, !SSLv3

      smtpd_recipient_restrictions =
          permit_sasl_authenticated
          permit_mynetworks
          reject_unauth_destination

      smtpd_sasl_auth_enable = yes
      smtpd_sasl_type = dovecot
      smtpd_sasl_path = private/auth
      smtpd_sasl_authenticated_header = yes
    '';
  };
}
