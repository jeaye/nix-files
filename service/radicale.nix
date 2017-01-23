{ config, pkgs, ... }:

{
  services.radicale = {
    enable = true;
    config =
    ''
[server]
## SSL
ssl = True
certificate = /var/lib/acme/pastespace.org/cert.pem
key = /var/lib/acme/pastespace.org/key.pem

[auth]
# Authentication method
# Value: None | htpasswd | IMAP | LDAP | PAM | courier | http | remote_user | custom
type = PAM

imap_hostname = localhost
imap_port = 143
imap_ssl = True

[git]
committer = Radicale <radicale@jeaye.com>

[logging]
debug = True
    '';
  };

  networking.firewall =
  {
    allowedTCPPorts =
    [
      5232 # caldav
    ];
  };
}
