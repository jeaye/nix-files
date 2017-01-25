{ config, pkgs, ... }:

{
  services.radicale = {
    enable = true;
    config =
    ''
[server]
base_prefix = /calendar/

[auth]
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
