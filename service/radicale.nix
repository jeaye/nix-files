{ config, pkgs, ... }:

{
  services.radicale = {
    enable = true;
    config =
    ''
[auth]
# Authentication method
# Value: None | htpasswd | IMAP | LDAP | PAM | courier | http | remote_user | custom
type = None

imap_hostname = localhost
imap_port = 143
imap_ssl = True

[git]
committer = Radicale <radicale@jeaye.com>

[logging]
debug = True
    '';
  };
}
