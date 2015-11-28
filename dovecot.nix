{ config, pkgs, ... }:

{
  services.dovecot2 = {
    enable = true;
    enableImap = true;
    enablePop3 = false;
    mailLocation = "maildir:~/Maildir";
    sslServerCert = "/etc/ssl/certs/mail.pem";
    sslServerKey = "/etc/ssl/private/mail.key";
    sslCACert =  "/etc/ssl/private/mail.csr";
    extraConfig = ''
      ssl = required

      namespace inbox {
        mailbox trash {
          auto = create
          special_use = \Trash
        }
        mailbox sent {
          auto = create
          special_use = \Sent
        }
        mailbox junk {
          auto = create
          special_use = \Junk
        }
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
}
