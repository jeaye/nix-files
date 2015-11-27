{ config, pkgs, ... }:

{
  systemd.services.fiche = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      User = "http";
      ExecStart = ''
        ${pkgs.fiche}/bin/fiche -d 104.238.146.252 -o /home/http/paste.jeaye.com -l /home/http/fiche.log
      '';
    };
  };
}
