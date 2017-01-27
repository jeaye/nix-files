{ config, pkgs, ... }:

{
  services.radicale = {
    enable = true;
    config =
    ''
[server]
base_prefix = /

[auth]
type = None

[rights]
type = owner_only

[git]
committer = Radicale <radicale@jeaye.com>

[logging]
debug = False
    '';
  };

  environment.etc =
  {
    "radicale/logging".text =
    ''
# Loggers, handlers and formatters keys

[loggers]
# Loggers names, main configuration slots
keys = root

[handlers]
# Logging handlers, defining logging output methods
keys = console

[formatters]
# Logging formatters
keys = simple,full

# Loggers

[logger_root]
# Root logger
level = DEBUG
handlers = console

# Handlers

[handler_console]
# Console handler
class = StreamHandler
level = INFO
args = (sys.stdout,)
formatter = simple

# Formatters

[formatter_simple]
# Simple output format
format = %(message)s

[formatter_full]
# Full output format
format = %(asctime)s - %(levelname)s: %(message)s
    '';
  };
}
