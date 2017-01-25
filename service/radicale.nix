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

[rights]
type = owner_only

[git]
committer = Radicale <radicale@jeaye.com>

[logging]
debug = True
    '';
  };
}
