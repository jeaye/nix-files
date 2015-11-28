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
    relayDomains = [];
    virtual = ''
      contact@pastespace.org     jeaye
    '';
    postmasterAlias = "root";
    rootAlias = "jeaye";
    extraAliases = ''
      # Basic system aliases -- these MUST be present
      MAILER-DAEMON:  postmaster

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
      #virtual_alias_domains = jeaye.com fu-er.com furthington.com arrownext.com

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
    # TODO: Clean up the duplication
    extraMasterConf = ''
      submission inet n       -       n       -       -       smtpd
        -o syslog_name=postfix/submission
        -o smtpd_tls_wrappermode=no
        -o smtpd_tls_security_level=encrypt
        -o smtpd_sasl_auth_enable=yes
        -o smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject
        -o milter_macro_daemon_name=ORIGINATING
        -o smtpd_sasl_type=dovecot
        -o smtpd_sasl_path=private/auth
    '';
  };
}
