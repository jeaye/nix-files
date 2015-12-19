nix-files
===

These configurations declaratively describe my VPS, running multiple websites
and services, using the [NixOS Linux distribution](http://nixos.org).

The main entry point describing the core system is `configuration.nix`; from
there, each item is split categorically.

### Managed bits
* System
  * GRUB, time, network, firewall, users, packages, etc
* Websites
  * jeaye.com
  * pastespace.org
* Mail server
  * IMAP (dovecot) + SMTP (postfix) + DKIM
* [Fiche](https://github.com/solusipse/fiche) service
  * Posts expire after 2 weeks
* SSL Certs (Let's Encrypt)

### Non-managed bits
* User passwords
* weechat/mutt configs
