nix-files
===

These configurations declaratively describe my VPS, running multiple websites
and services, using the [NixOS Linux distribution](http://nixos.org).

The main entry point describing the core system is `configuration.nix`; from
there, each item is split categorically.

### Managed bits
* Websites
  * jeaye.com
  * pastespace.org
* Mail server
  * IMAP (dovecot) + SMTP (postfix)
* [Fiche](https://github.com/solusipse/fiche) service
  * Posts expire after 2 weeks

### Non-managed bits
* User passwords
* /home/http repositories
* /etc/ssl keys and certs
* weechat/mutt configs
