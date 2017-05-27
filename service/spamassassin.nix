{ config, pkgs, ... }:

{
  services.spamassassin.enable = true;

  # Regularly update spamassassin rules and train
  services.cron.systemCronJobs =
  [
    "@daily root ${pkgs.spamassassin}/bin/sa-update"
    "@daily root /etc/train-spamassassin"
  ];

  system.activationScripts =
  {
    spamassassin =
    {
      deps = [];
      text =
      ''
        # Make sure spamassassin database is present
        if ! [ -d /etc/spamassassin ];
        then
          cp -r ${pkgs.spamassassin}/share/spamassassin /etc
        fi
      '';
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/7915#issuecomment-104882091
  environment.etc =
  {
    "procmailrc" =
    {
      text =
      ''
        SHELL="/bin/bash"
        LINEBUF=4096
        SENDMAIL="/run/wrappers/bin/sendmail -oi -t"
        DEFAULT="$HOME/Maildir/"
        MAILDIR="$HOME/Maildir/"
        DROPPRIVS="yes"
        VERBOSE=on
        LOGFILE=$HOME/.procmail.log

        :0fw
        * < 512000
        | ${pkgs.spamassassin}/bin/spamc

        # Apply user rules first
        INCLUDERC="$HOME/.procmailrc

        :0:
        * ^X-Spam-Status: Yes
        .Spam/

        # Work around procmail bug: any output on stderr will cause the
        # "F" in "From" to be dropped. This will re-add it.
        :0
        * ^^rom[ ]
        {
          LOG="*** Dropped F off From_ header! Fixing up. "

          :0 fhw
          | sed -e '1s/^/F/'
        }
      '';
    };
    "train-spamassassin" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        # TODO: Possibly run for other users
        sa-learn --no-sync --spam /etc/user/jeaye/Maildir/.Spam/{cur,new}
        sa-learn --no-sync --ham /etc/user/jeaye/Maildir/.Ham/{cur,new}
        sa-learn --no-sync --ham /etc/user/jeaye/Maildir/.ML*/{cur,new}
        sa-learn --sync
      '';
      mode = "0774";
    };
  };
}
