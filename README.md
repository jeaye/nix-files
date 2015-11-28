nix-files
===

These configurations declaratively describe my VPS, running multiple websites
and services, using the [NixOS Linux distribution](http://nixos.org).

The main entry point describing the core system is `configuration.nix`; from
there, each item is split categorically.

### Non-managed bits
* /home/http repositories
* /etc/ssl keys and certs
