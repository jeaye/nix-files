{ config, pkgs, ... }:

{
  security.pam.loginLimits =
  [
    { domain = "*"; item = "nproc"; type = "soft"; value = "256"; }
    { domain = "*"; item = "nproc"; type = "hard"; value = "256"; }
    { domain = "*"; item = "maxlogins"; type = "hard"; value = "3"; }
    { domain = "*"; item = "nofile"; type = "hard"; value = "512"; }
  ];

  # Required for SSH access.
  users.groups.ssh-user = {};

  # Ensure /etc/user is readable.
  system.activationScripts =
  {
    readable-home =
    {
      text =
      ''
        chmod a+r /etc/user
      '';
    };
  };
}
