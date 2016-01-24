{ config, pkgs, ... }:

{
  services.dovecot2 =
  {
    enable = true;
    enableImap = true;
    enablePop3 = false;
    mailLocation = "maildir:~/Maildir";
    sslServerCert = "/var/lib/acme/pastespace.org/cert.pem";
    sslServerKey = "/var/lib/acme/pastespace.org/key.pem";
    sslCACert =  "/var/lib/acme/pastespace.org/chain.pem";
    extraConfig =
    ''
      ssl = required

      protocol imap {
        mail_plugins = $mail_plugins autocreate
      }

      # TODO: Update to namespaces
      plugin {
        autocreate1 = Sent
        autocreate2 = Drafts
        autocreate3 = Spam
        autocreate4 = Ham
        autosubscribe1 = Sent
        autosubscribe2 = Drafts
        autosubscribe3 = Spam
        autosubscribe4 = Ham
      }

      service auth {
        unix_listener /var/postfix/queue/private/auth {
          mode = 0660
          user = postfix
          group = postfix
        }
      }
    '';
  };

  networking.firewall =
  {
    allowedTCPPorts =
    [
      143 # imap
      993 # imap
    ];
  };
}
