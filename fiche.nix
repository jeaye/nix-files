{ config, pkgs, ... }:

{
  systemd.services.fiche = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      User = "http";
      ExecStart = ''
        ${pkgs.fiche}/bin/fiche -d pastespace.org -o /home/http/paste.jeaye.com -l /var/log/fiche
      '';
    };
  };

  # Clean up old pastes
  services.cron.systemCronJobs = [
    "*/1 * * * * find /home/http/paste.jeaye.com -mmin +2 type d -exec rm -r {} \;"
  ];
}
