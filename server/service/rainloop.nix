{ config, pkgs, lib, ... }:

{
  environment.etc =
  {
    "upgrade-rainloop" =
    {
      text =
      ''
        export PATH=${pkgs.curl}/bin:${pkgs.wget}/bin:${pkgs.gnupg}/bin:${pkgs.rsync}/bin:${pkgs.unzip}/bin:$PATH
        ${lib.readFile ./data/upgrade-rainloop}
      '';
      mode = "0774";
    };
  };

  services.cron.systemCronJobs =
  [
    "@daily root /etc/upgrade-rainloop"
  ];
}
