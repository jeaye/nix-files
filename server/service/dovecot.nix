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
        autocreate = Trash
        autocreate2 = Sent
        autocreate3 = Drafts
        autocreate4 = Spam
        autosubscribe = Trash
        autosubscribe2 = Sent
        autosubscribe3 = Drafts
        autosubscribe4 = Spam
      }

      service auth {
        unix_listener /var/lib/postfix/queue/private/auth {
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
