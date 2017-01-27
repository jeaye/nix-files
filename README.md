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
  * safepaste.org
  * jank-lang.org
* Mail server
  * IMAP (dovecot) + SMTP (postfix) + DKIM
* [safepaste](https://github.com/jeaye/safepaste) service
* [jank benchmark visualizer](http://bench.jank-lang.org/) service
* caldav service
* SSL Certs (Let's Encrypt)
* Persistent weechat/mutt sessions

### Non-managed bits
* User passwords
