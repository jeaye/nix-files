{ config, pkgs, ... }:

{
  # Clean up old files
  services.cron.systemCronJobs =
  [
    "0 0 * * * http ${pkgs.findutils}/bin/find /etc/user/http/upload.jeaye.com/tmp -mtime +2 -type f -exec rm -vf {} \\;"
  ];
}
