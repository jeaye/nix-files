{ config, pkgs, ... }:

{
  services.spamassassin.enable = true;
  services.spamassassin.debug = true;

  system.activationScripts =
  {
    spamassassin =
    {
      deps = [];
      text =
      ''
        # Make sure SpamAssassin database is present
        if ! [ -d /etc/spamassassin ];
        then
          cp -r ${pkgs.spamassassin}/share/spamassassin /etc
        fi
      '';
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/7915#issuecomment-104882091
  environment.etc =
  [
    {
      target = "procmailrc";
      source = pkgs.writeText "procmailrc"
      ''
        # generated global procmail configuration -- do not edit

        DEFAULT="/var/spool/mail/$LOGNAME"
        DROPPRIVS="yes"

        :0fw
        * < 512000
        | ${pkgs.spamassassin}/bin/spamc
      '';
    }
  ];
}
