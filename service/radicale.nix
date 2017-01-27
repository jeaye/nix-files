{ config, pkgs, ... }:

{
  services.radicale = {
    enable = true;
    config =
    ''
[server]
hosts = 0.0.0.0:5232
base_prefix = /
can_skip_base_prefix = True

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

  environment.etc =
  {
    "radicale/logging".text =
    ''
[loggers]
keys = root

[handlers]
keys = console,file

[formatters]
keys = full

[logger_root]
level = DEBUG
handlers = console,file

[handler_console]
class = StreamHandler
args = (sys.stdout,)
formatter = full

[handler_file]
# File handler
class = FileHandler
args = ('/tmp/radicale',)
formatter = full

[formatter_full]
format = %(asctime)s - %(levelname)s: %(message)s
    '';
  };
}
