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
  };
}
