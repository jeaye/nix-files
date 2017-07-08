{ config, pkgs, ... }:

{
  services.spamassassin =
  {
    enable = true;
    config =
    ''
      use_bayes 1
      bayes_auto_learn 0
      bayes_path /var/lib/spamassassin/bayes
      bayes_file_mode 0777
    '';
  };

  # Regularly update spamassassin rules and train
  services.cron.systemCronJobs =
  [
    "@daily root ${pkgs.spamassassin}/bin/sa-update && systemctl restart spamd"
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
        bayes_path=/var/lib/spamassassin/bayes
        if ! [ -d $bayes_path ];
        then
          mkdir $bayes_path
          chown spamd:spamd -R $bayes_path
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

        # Apply user rules
        INCLUDERC=$HOME/.procmailrc
      '';
    };
    "train-spamassassin" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        # TODO: Possibly run for other users
        ${pkgs.spamassassin}/bin/sa-learn --no-sync --spam /etc/user/jeaye/Maildir/.Spam/{cur,new}
        ${pkgs.spamassassin}/bin/sa-learn --no-sync --ham /etc/user/jeaye/Maildir/.Ham/{cur,new}
        ${pkgs.spamassassin}/bin/sa-learn --no-sync --ham /etc/user/jeaye/Maildir/.ML*/{cur,new}
        ${pkgs.spamassassin}/bin/sa-learn --sync
      '';
      mode = "0774";
    };
  };
}
