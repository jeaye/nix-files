{ config, pkgs, ... }:

{
  services.radicale = {
    enable = true;
    config =
    ''
[server]
hosts = 0.0.0.0:5232
#base_prefix = /calendar/
#can_skip_base_prefix = True

[auth]
type = None

[rights]
type = none

#[git]
#committer = Radicale <radicale@jeaye.com>

[logging]
debug = False
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
level = WARNING
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
