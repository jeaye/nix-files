{ config, pkgs, ... }:

{
  services.spamassassin.enable = true;
  services.spamassassin.debug = true;

  # Regularly update spamassassin rules
  services.cron.systemCronJobs =
  [
    "@daily root ${pkgs.spamassassin}/bin/sa-update"
  ];

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
        SHELL="/bin/bash"
        SENDMAIL="/run/wrappers/bin/sendmail -oi -t"
        LOGFILE="/var/log/procmail.log"
        DEFAULT="$HOME/Maildir/"
        MAILDIR="$HOME/Maildir/"
        DROPPRIVS="yes"

        :0fw
        * < 512000
        | ${pkgs.spamassassin}/bin/spamc

        :0:
        * ^X-Spam-Level: ****
        Spam
      '';
    }
  ];
}
