nix-files
===

These configurations declaratively describe my VPS, running multiple websites
and services, using the [NixOS Linux distribution](http://nixos.org).

The main entry point describing the core system is `configuration.nix`; from
there, each item is split categorically.

### Managed bits
* Multiple websites
  * jeaye.com
  * fu-er.com
  * furthington.com
  * pastespace.org
* Mail server for all of the above sites
  * IMAP + SMTP
* Fiche service
  * Posts are cleaned up after 2 weeks

### Non-managed bits
* /home/http repositories
* /etc/ssl keys and certs
* weechat/mutt configs
