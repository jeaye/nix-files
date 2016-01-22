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

        title="Failed SSH logins"
        printf "%*s\n\n" $(((''${#title}+$COLUMNS)/2)) "$title"
        journalctl -u sshd | grep 'Failed password' \
                           | awk '{print $1,$2}' \
                           | sort -k 1,1M -k 2n \
                           | uniq -c
                           | sed -e '^s/\s\+//g' \
                                 -e 's/\(\S\+\) \+\(\S\+\) \+\(\S\+\)/\2 \3\t\1/'
      '';
      mode = "0774";
    };
    "admin/daily-succeeded-ssh-logins" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        title="Accepted SSH logins"
        printf "%*s\n\n" $(((''${#title}+$COLUMNS)/2)) "$title"
        journalctl -u sshd \
          | grep 'Accepted' \
          | sed 's/\(\S\+\) \(\S\+\).*for \(\S\+\) from.*/\1 \2 \3/' \
          | uniq \
          | tr '\n' '|' \
          | sed -e ':loop' \
                -e 's/\(\S\+\) \(\S\+\) \(.\+\)|\1 \2 \(\S\+\)/\1 \2 \3 \4/g' \
                -e 't loop' \
          | tr '|' '\n'
          | sed -e 's/\(\S\+\) \+\(\S\+\) \+\(.\+\)/\1 \2\t\3/'
      '';
      mode = "0774";
    };
    "admin/daily-port-scans" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        title="Port scans detected"
        printf "%*s\n\n" $(((''${#title}+$COLUMNS)/2)) "$title"
        journalctl | grep 'rejected connection:' \
                   | awk '{print $1,$2}' \
                   | sort -k 1,1M -k 2n \
                   | uniq -c
                   | sed -e 's/^\s\+//g' \
                         -e 's/\(\S\+\) \+\(\S\+\) \+\(\S\+\)/\2 \3\t\1/'
      '';
      mode = "0774";
    };
    "admin/daily-postfix-dos" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu

        title="Postfix DOS attempts"
        printf "%*s\n\n" $(((''${#title}+$COLUMNS)/2)) "$title"
        journalctl -u postfix | grep 'lost connection after EHLO from' \
                              | awk '{print $1,$2}' \
                              | sort -k 1,1M -k 2n \
                              | uniq -c
                              | sed -e 's/^\s\+//g' \
                                    -e 's/\(\S\+\) \+\(\S\+\) \+\(\S\+\)/\2 \3\t\1/'
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
