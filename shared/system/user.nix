{ config, pkgs, ... }:

{
# TODO: Good values here.
# security.pam.loginLimits =
# [
#   { domain = "*"; item = "nproc"; type = "soft"; value = "1024"; }
#   { domain = "*"; item = "nproc"; type = "hard"; value = "1024"; }
#   { domain = "*"; item = "maxlogins"; type = "hard"; value = "3"; }
#   { domain = "*"; item = "nofile"; type = "hard"; value = "1024"; }
# ];

  # Required for SSH access.
  users.groups.ssh = {};
}
