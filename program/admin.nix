{ config, pkgs, ... }:

{
  # Some helpful scripts and packages for diagnostics
  environment.systemPackages = with pkgs;
  [
    pcre
  ];

  environment.etc =
  {
    "admin/daily-failed-ssh-logins" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        journalctl -u sshd | grep 'Failed password' \
                           | grep sshd \
                           | awk '{print $1,$2}' \
                           | sort -k 1,1M -k 2n \
                           | uniq -c
      '';
      mode = "0774";
    };
    "admin/daily-port-scans" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        journalctl | grep 'rejected connection:' \
                   | awk '{print $1,$2}' \
                   | sort -k 1,1M -k 2n \
                   | uniq -c
      '';
      mode = "0774";
    };
    "admin/daily-postfix-dos" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        journalctl -u postfix | grep 'lost connection after EHLO from' \
                              | awk '{print $1,$2}' \
                              | sort -k 1,1M -k 2n \
                              | uniq -c
      '';
      mode = "0774";
    };
    "admin/unban-fail2ban-ip" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        jails=$(fail2ban-client status | pcregrep -o1 "list:\s*(\w.*)" | sed 's/,//g')
        for jail in $jails;
        do
          echo "Removing $1 from $jail"
          fail2ban-client set $jail unbanip $1 > /dev/null 2>&1 || true
        done
      '';
      mode = "0774";
    };
  };
}
