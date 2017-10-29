nix-files
===

These configurations declaratively describe both my VPS, running multiple
websites and services, as well we my workstation. These machines run using the
[NixOS Linux distribution](http://nixos.org).

The main entry point describing the core system is `configuration.nix`; from
there, each item is split categorically. Each installation will provide a link
from `/etc/nixos/configuration.nix` to either `workstation/configuration.nix` or
`server/configuration.nix`.

## Workstation
### Managed bits
### Non-managed bits

## Server
### Managed bits
* System
  * GRUB, time, network, firewall, users, packages, etc
* Several websites
* Mail server
  * IMAP (dovecot) + SMTP (postfix) + DKIM
* Rainloop web client
* [safepaste](https://github.com/jeaye/safepaste) service
* [jank benchmark visualizer](http://bench.jank-lang.org/) service
* caldav service
* SSL Certs (Let's Encrypt)
* Persistent weechat/mutt sessions

### Non-managed bits
* User passwords
