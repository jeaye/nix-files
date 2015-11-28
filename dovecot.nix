{ config, pkgs, ... }:

{
  services.dovecot2 = {
    enable = true;
    enableImap = true;
    enablePop3 = false;
    mailLocation = "maildir:~/Maildir";
    sslServerCert = "/etc/ssl/certs/mail.pem";
    sslServerKey = "/etc/ssl/private/mail.key";
    extraConfig = ''
      ssl = required
    '';
    extraConfig = ''
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
        unix_listener /var/spool/postfix/private/auth {
          mode = 0660
          user = postfix
          group = postfix
        }
      }
    '';
  };
}
