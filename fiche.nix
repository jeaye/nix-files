{ config, pkgs, fetchFromGitHub, ... }:

{
  environment.etc.fiche = fetchFromGitHub {
    owner = "solusipse";
    repo = "fiche";
    rev = "8f3e23d3de66aa894f78417523cb6aeb208b6d60";
    sha256 = "1fhdp90k4dv5vps3fzip0g64haf8j6vp2mpk17w89qg7kyb1bwi6";
  };

  #systemd.services.fiche = {
  #  wantedBy = [ "multi-user.target" ];
  #  after = [ "network.target" ];
  #  serviceConfig = {
  #    User = "http";
  #    ExecStart = ''
  #      /etc/fiche -d paste.jeaye.com -o /home/http/paste.jeaye.com -l /home/http/fiche.log
  #    '';
  #  };
  #};
}
