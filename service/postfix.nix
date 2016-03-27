{ config, pkgs, ... }:

{
  services.postfix = rec
  {
    enable = true;
    domain = "pastespace.org";
    hostname = "${domain}";
    origin = "${domain}";
    destination =
    [
      "${hostname}"
      "${domain}"
      "localhost.${domain}"
      "localhost"
    ];
    networksStyle = "host";
    relayDomains = [];
    virtual =
    ''
      contact@pastespace.org     jeaye
      contact@safepaste.org      jeaye
      contact@arrownext.com      jeaye
      contact@jeaye.com          jeaye
      contact@trustcoin.org      jeaye
      contact@fu-er.com          fu-er
      contact@penelope-art.com   fu-er
      contact@penny-art.com      fu-er
    '';
    postmasterAlias = "root";
    rootAlias = "jeaye";

    extraAliases =
    ''
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

      # Local users
      safepaste: jeaye
    '';
    extraConfig =
    ''
      home_mailbox = Maildir/
      virtual_alias_domains = jeaye.com safepaste.org trustcoin.org arrownext.com fu-er.com penelope-art.com penny-art.com

      # Prevent others from checking for valid emails
      disable_vrfy_command = yes

      # Security
      smtpd_use_tls = yes
      smtpd_tls_cert_file = /var/lib/acme/pastespace.org/cert.pem
      smtpd_tls_key_file = /var/lib/acme/pastespace.org/key.pem
      smtpd_tls_session_cache_database = btree:''${queue_directory}/smtpd_scache
      smtpd_tls_wrappermode = no
      smtpd_tls_security_level = may
      smtpd_tls_eecdh_grade = ultra
      smtpd_tls_protocols = !SSLv2, !SSLv3
      smtpd_tls_auth_only = yes
      smtpd_tls_loglevel = 1

      smtpd_sasl_auth_enable = yes
      smtpd_sasl_type = dovecot
      smtpd_sasl_path = private/auth
      smtpd_sasl_authenticated_header = yes

      smtp_tls_security_level = may
      smtp_tls_eecdh_grade = ultra
      smtp_tls_cert_file = /var/lib/acme/pastespace.org/cert.pem
      smtp_tls_key_file = /var/lib/acme/pastespace.org/key.pem
      smtp_tls_session_cache_database = btree:''${queue_directory}/smtp_scache
      smtp_tls_loglevel = 1

      tls_random_source = dev:/dev/urandom
      tls_eecdh_strong_curve = prime256v1
      tls_eecdh_ultra_curve = secp384r1

      smtpd_relay_restrictions =
        permit_sasl_authenticated
        permit_mynetworks
        reject_unauth_destination

      smtpd_recipient_restrictions =
        permit_sasl_authenticated
        permit_mynetworks
        reject_unauth_destination
        reject_invalid_hostname
        reject_non_fqdn_hostname
        reject_non_fqdn_sender
        reject_non_fqdn_recipient
        reject_unknown_reverse_client_hostname

      smtpd_helo_restrictions =
        permit_sasl_authenticated
        permit_mynetworks
        reject_unknown_helo_hostname
        reject_invalid_hostname
        reject_unauth_pipelining
        reject_non_fqdn_hostname

      smtpd_helo_required = yes

      smtpd_data_restrictions =
        reject_unauth_pipelining

      # OpenDKIM mail verification
      milter_default_action = accept
      milter_protocol = 2
      smtpd_milters = unix:/var/run/opendkim/opendkim.sock
      non_smtpd_milters = unix:/var/run/opendkim/opendkim.sock
    '';
    extraMasterConf =
    ''
      submission inet n       -       n       -       -       smtpd
        -o syslog_name=postfix/submission
        -o milter_macro_daemon_name=ORIGINATING
        -o smtpd_tls_security_level=encrypt
        -o smtpd_sasl_security_options=noanonymous
    '';
  };

  networking.firewall =
  {
    allowedTCPPorts =
    [
      25 # smtp
      587 # smtp
    ];
  };
}
